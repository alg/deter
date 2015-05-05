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

  test "creating library" do
    VCR.use_cassette "deterlab/libraries/create-library" do
      login

      libid = "#{@username}:TestLibrary3"
      assert DeterLab.create_library(@username, libid, access_lists: [
        LibraryMember.new('system:world', [ LibraryMember::READ_LIBRARY ])
      ], description: "Some library")

      libs = DeterLab.view_libraries(@username)
      lib  = libs.find { |l| l.libid == libid }

      assert_not_nil lib
      assert_equal   @username, lib.owner
      assert_equal   [ LibraryMember.new("system:world", [ LibraryMember::READ_LIBRARY ]) ], lib.members
    end
  end
end
