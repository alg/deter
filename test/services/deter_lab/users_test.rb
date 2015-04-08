require 'services/deter_lab/abstract_test'
require 'webmock/minitest'

class DeterLab::UsersTest < DeterLab::AbstractTest

  test "it should return false for bad login" do
    VCR.use_cassette "deterlab/users/login-bad" do
      assert !DeterLab.valid_credentials?("unk", "badpass")
    end
  end

  test "it should return true for good login" do
    VCR.use_cassette "deterlab/users/login-good" do
      login
      assert_not_nil SslKeyStorage.get(@username)
    end
  end

  test "getting user profile description" do
    VCR.use_cassette "deterlab/users/user-profile-description" do
      fields = DeterLab.get_user_profile_description
      assert_equal ProfileField.new("URL", "string", true, "READ_WRITE", "URL", nil, nil, "0", nil), fields["URL"]
      assert_equal ProfileField.new("phone", "string", false, "READ_WRITE", "Phone", "[0-9-\\s\\.\\(\\)\\+]+", "Numbers, whitespace, parens, and dots or dashes", "15", nil), fields["phone"]
    end
  end

  test "getting user profile" do
    VCR.use_cassette "deterlab/users/user-profile" do
      login
      profile = DeterLab.get_user_profile(@username)
      assert_equal '06405', profile['zip']
    end
  end

  test "updating user profile" do
    VCR.use_cassette "deterlab/users/change-profile-success" do
      login
      errors = DeterLab.change_user_profile(@username, state: "CT", country: "United States")
      assert_equal({}, errors)
    end
  end

  test "failing to update the profile" do
    VCR.use_cassette "deterlab/users/change-profile-failure" do
      login
      errors = DeterLab.change_user_profile(@username, phone: "")
      assert_equal({ "phone" => "Misformatted attribute. Expected Numbers, whitespace, parens, and dots or dashes" }, errors)
    end
  end

  test "changing password successfully" do
    VCR.use_cassette "deterlab/users/change-password-successfully" do
      login
      assert DeterLab.change_password(@username, @password)
    end
  end

  test "requesting password reset" do
    VCR.use_cassette "deterlab/users/request-password-reset" do
      assert DeterLab.request_password_reset(@username, "http://localhost:3000/reset_password/")
    end
  end

  test "requesting password reset for empty username" do
    VCR.use_cassette "deterlab/users/request-password-reset-empty" do
      assert !DeterLab.request_password_reset("", "http://localhost:3000/reset_password/")
    end
  end

  test "requesting password reset for unknown user" do
    VCR.use_cassette "deterlab/users/request-password-reset-unknown" do
      assert !DeterLab.request_password_reset("unknown", "http://localhost:3000/reset_password/")
    end
  end

  test "changing password via challenge" do
    VCR.use_cassette "deterlab/users/change-password-challenge-bad" do
      assert !DeterLab.change_password_challenge("challenge", "new_pass")
    end
  end

  test "creating user successfully" do
    VCR.use_cassette "deterlab/users/create-user" do
      assert DeterLab.create_user(user_profile)
    end
  end

  test "creating invalid user" do
    VCR.use_cassette "deterlab/users/create-user-failure" do
      ex = assert_raise DeterLab::RequestError do
        DeterLab.create_user({})
      end
      assert ex.message =~ /Required attribute .* not present/
    end
  end

  test "create user no confirm" do
    VCR.use_cassette "deterlab/users/create-user-no-confirm" do
      login
      assert DeterLab.create_user_no_confirm(@username, 'Mark', user_profile)
    end
  end

  private

  def user_profile
    { name: "Mark Smith",
      email: "mark@smith.com",
      phone: "1234567891",
      title: "Mr",
      affiliation: "X Corp",
      affiliation_abbrev: "XC",
      URL: "http://xcorp.org",
      address1: "1 Main st.",
      address2: "",
      city: "Carrum",
      state: "Vic",
      zip: "3127",
      country: "Australia" }
  end

end
