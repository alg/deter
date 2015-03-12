require 'services/deter_lab/abstract_test'

class DeterLab::LibrariesTest < DeterLab::AbstractTest

  test "getting profile description" do
    VCR.use_cassette "deterlab/libraries/get-profile-description" do
      fields = DeterLab.get_libraries_profile_description
      assert_equal [ ProfileField.new("description", "string", false, "READ_WRITE", "Description", nil, nil, "0", nil) ], fields
    end
  end

  test "viewing libraries" do
    VCR.use_cassette "deterlab/libraries/view-libraries" do
      login
      list = DeterLab.view_libraries(@username)
      assert_equal [
      ], list
    end
  end

end
