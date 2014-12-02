require 'test_helper'

class DeterLabTest < ActiveSupport::TestCase

  setup do
    @username = TestsConfig['username']
    @password = TestsConfig['password']
  end

  test "version returns version" do
    VCR.use_cassette "deterlab-version" do
      assert_equal "0.2/0.0", DeterLab.version
    end
  end

  test "it should return false for bad login" do
    VCR.use_cassette "deterlab-login-bad" do
      assert !DeterLab.valid_credentials?("unk", "badpass")
    end
  end

  test "it should return true for good login" do
    VCR.use_cassette "deterlab-confidential-login-good" do
      login
      assert_not_nil SslKeyStorage.get(@username)
    end
  end

  # -------------------------------------------------------------------------------------

  test "getting project profile description" do
    VCR.use_cassette "deterlab-project-profile-description" do
      fields = DeterLab.get_project_profile_description

      # <struct ProfileField name="URL",         data_type="string", optional=true,  access="READ_WRITE",
      #   description="URL", format=nil, format_description=nil, length_hint="0", value=nil>,
      # <struct ProfileField name="affiliation", data_type="string", optional=true,  access="READ_WRITE",
      #   description="Affiliation", format=nil, format_description=nil, length_hint="0", value=nil>
      # <struct ProfileField name="description", data_type="string", optional=false, access="READ_WRITE",
      #   description="Description", format=nil, format_description=nil, length_hint="0", value=nil>
      # <struct ProfileField name="funders",     data_type="string", optional=true,  access="READ_WRITE",
      #   description="Funders", format=nil, format_description=nil, length_hint="0", value=nil>]

      assert_equal ProfileField.new("URL", "string", true, "READ_WRITE", "URL", nil, nil, "0", nil), fields["URL"]
      assert_equal ProfileField.new("funders", "string", true, "READ_WRITE", "Funders", nil, nil, "0", nil), fields["funders"]
    end
  end

  test "getting user profile description" do
    VCR.use_cassette "deterlab-user-profile-description" do
      fields = DeterLab.get_user_profile_description
      assert_equal ProfileField.new("URL", "string", true, "READ_WRITE", "URL", nil, nil, "0", nil), fields["URL"]
      assert_equal ProfileField.new("phone", "string", false, "READ_WRITE", "Phone", "[0-9-\\s\\.\\(\\)\\+]+", "Numbers, whitespace, parens, and dots or dashes", "15", nil), fields["phone"]
    end
  end

  test "getting user profile" do
    VCR.use_cassette "deterlab-confidential-user-profile" do
      login
      profile = DeterLab.get_user_profile(@username)
      assert_equal '06405', profile['zip']
    end
  end

  test "updating user profile" do
    VCR.use_cassette "deterlab-confidential-change-profile-success" do
      login
      errors = DeterLab.change_user_profile(@username, state: "CT", country: "United States")
      assert_equal({}, errors)
    end
  end

  test "failing to update the profile" do
    VCR.use_cassette "deterlab-confidential-change-profile-failure" do
      login
      errors = DeterLab.change_user_profile(@username, phone: "")
      assert_equal({ "phone" => "Misformatted attribute. Expected Numbers, whitespace, parens, and dots or dashes" }, errors)
    end
  end

  # -------------------------------------------------------------------------------------

  test "getting user projects" do
    VCR.use_cassette "deterlab-confidential-user-projects" do
      login
      projects = DeterLab.get_user_projects(@username)

      assert_equal [
        Project.new("admin", "deterboss", true,
          [ ProjectMember.new("deterboss", ["CREATE_EXPERIMENT", "CREATE_LIBRARY", "REMOVE_USER", "CREATE_CIRCLE", "ADD_USER"]),
            ProjectMember.new("bfdh", ["CREATE_EXPERIMENT", "CREATE_LIBRARY", "REMOVE_USER", "CREATE_CIRCLE", "ADD_USER"]),
            ProjectMember.new("faber", ["CREATE_EXPERIMENT", "CREATE_LIBRARY", "REMOVE_USER", "CREATE_CIRCLE", "ADD_USER"])
          ]),
        Project.new("SPIdev", "faber", true,
          [ ProjectMember.new("bfdh", ["CREATE_EXPERIMENT", "CREATE_LIBRARY", "REMOVE_USER", "CREATE_CIRCLE", "ADD_USER"]),
            ProjectMember.new("jsebes", ["CREATE_EXPERIMENT", "CREATE_LIBRARY", "REMOVE_USER", "CREATE_CIRCLE", "ADD_USER"]),
            ProjectMember.new("faber", ["CREATE_EXPERIMENT", "CREATE_LIBRARY", "REMOVE_USER", "CREATE_CIRCLE", "ADD_USER"])
          ]),
        Project.new("Megaproj", "bfdh", true,
          [ ProjectMember.new("bfdh", ["CREATE_EXPERIMENT", "CREATE_LIBRARY", "REMOVE_USER", "CREATE_CIRCLE", "ADD_USER"]) ])
      ], projects
    end
  end

  test "creating a project successfully" do
    VCR.use_cassette "deterlab-confidential-create-project" do
      login
      assert DeterLab.create_project(@username, "unit-test-project-3", { description: "Unit test project", URL: "http://sample.com/", "test-open" => "test" })
    end
  end

  test "failing to create a project" do
    VCR.use_cassette "deterlab-confidential-create-project-failure" do
      login
      assert_raises DeterLab::RequestError do
        DeterLab.create_project(@username, "unit-test-project-failure", { description: "" })
      end
    end
  end

  test "deleting a project" do
    VCR.use_cassette "deterlab-confidential-delete-project" do
      login
      assert DeterLab.create_project(@username, "unit-test-delete", { "description" => "Project for unit test deletion", "test-open" => "test" })
      assert DeterLab.remove_project(@username, "unit-test-delete")
    end
  end

  test "failed deleting of a project" do
    VCR.use_cassette "deterlab-confidential-delete-project-failure" do
      login
      err = assert_raises DeterLab::RequestError do
        DeterLab.remove_project(@username, "missing")
      end

      assert_equal "Invalid projectid", err.message
    end
  end

  # -------------------------------------------------------------------------------------

  test "getting experiments" do
    VCR.use_cassette "deterlab-confidential-user-experiments" do
      login
      list = DeterLab.get_user_experiments(@username)
      assert_equal [
        Experiment.new("Megaproj:One", "bfdh", [
          ExperimentACL.new("Megaproj:Megaproj", [ "MODIFY_EXPERIMENT_ACCESS", "MODIFY_EXPERIMENT", "READ_EXPERIMENT" ]),
          ExperimentACL.new("bfdh:bfdh", [ "MODIFY_EXPERIMENT_ACCESS", "MODIFY_EXPERIMENT", "READ_EXPERIMENT" ])
        ])
      ], list
    end
  end

  # -------------------------------------------------------------------------------------

  test "changing password successfully" do
    VCR.use_cassette "deterlab-confidential-change-password-successfully" do
      login
      assert DeterLab.change_password(@username, @password)
    end
  end

  # -------------------------------------------------------------------------------------

  test "requesting password reset" do
    VCR.use_cassette "deterlab-request-password-reset" do
      assert DeterLab.request_password_reset(@username, "http://localhost:3000/reset_password/")
    end
  end

  test "requesting password reset for empty username" do
    VCR.use_cassette "deterlab-request-password-reset-empty" do
      assert !DeterLab.request_password_reset("", "http://localhost:3000/reset_password/")
    end
  end

  test "requesting password reset for unknown user" do
    VCR.use_cassette "deterlab-request-password-reset-unknown" do
      assert !DeterLab.request_password_reset("unknown", "http://localhost:3000/reset_password/")
    end
  end

  # -------------------------------------------------------------------------------------

  test "changing password via challenge" do
    VCR.use_cassette "deterlab-change-password-challenge-bad" do
      assert !DeterLab.change_password_challenge("challenge", "new_pass")
    end
  end

  # -------------------------------------------------------------------------------------

  private

  def login
    skip("Valid test user is missing from tests-config.yml") if @username.blank? or @password.blank?
    assert DeterLab.valid_credentials?(@username, @password)
  end
end
