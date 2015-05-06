require 'services/deter_lab/abstract_test'

class DeterLab::LibrariesTest < DeterLab::AbstractTest

  # test "getting profile description" do
  #   VCR.use_cassette "deterlab/libraries/get-profile-description" do
  #     fields = DeterLab.get_libraries_profile_description
  #     assert_equal [ ProfileField.new("description", "string", false, "READ_WRITE", "Description", nil, nil, "0", nil) ], fields
  #   end
  # end

  # test "viewing libraries" do
  #   VCR.use_cassette "deterlab/libraries/view-libraries" do
  #     login
  #     list = DeterLab.view_libraries(@username)
  #     assert_equal [
  #     ], list
  #   end
  # end

  # test "creating library" do
  #   VCR.use_cassette "deterlab/libraries/create-library" do
  #     login

  #     libid = "#{@username}:TestLibrary3"
  #     assert DeterLab.create_library(@username, libid, access_lists: [
  #       LibraryMember.new('system:world', [ LibraryMember::READ_LIBRARY ])
  #     ], description: "Some library")

  #     libs = DeterLab.view_libraries(@username)
  #     lib  = libs.find { |l| l.libid == libid }

  #     assert_not_nil lib
  #     assert_equal   @username, lib.owner
  #     assert_equal   [ LibraryMember.new("system:world", [ LibraryMember::READ_LIBRARY ]) ], lib.members
  #   end
  # end

  # test "creating library with experiments" do
  #   VCR.use_cassette "deterlab/libraries/create-library-with-experiments" do
  #     login 'admin_user'

  #     ename = "TestLibraryExperiment4"
  #     expid = "aadams:#{ename}"
  #     assert DeterLab.create_experiment(@username, "aadams", ename, { description: "Test library exp" }, "aadams")

  #     libid = "aadams:TestLibrary4"
  #     assert DeterLab.create_library(@username, libid, { experiments: [ expid ], description: "Test" }, "aadams")

  #     libs = DeterLab.view_libraries(@username, "aadams")
  #     lib  = libs.find { |l| l.libid == libid }

  #     assert_equal [ expid ], lib.experiments
  #   end
  # end

  test "creating library with experiments 2" do
    VCR.use_cassette "deterlab/libraries/create-library-with-experiments-john", record: :all do
      login 'admin_user'

      n = Time.now.to_i
      owner = "john"
      ename1 = "HelloWorld1#{n}"
      expid1 = "#{owner}:#{ename1}"
      assert DeterLab.create_experiment(@username, owner, ename1, {
        description: "Test library exp",
        access_lists: [
          ExperimentACL.new('system:world', 'ALL_PERMS'),
          ExperimentACL.new("#{owner}:#{owner}", 'ALL_PERMS')
        ]
      }, owner)

      ename2 = "HelloWorld2#{n}"
      expid2 = "#{owner}:#{ename2}"
      assert DeterLab.create_experiment(@username, owner, ename2, {
        description: "Test library exp",
        access_lists: [
          ExperimentACL.new('system:world', 'ALL_PERMS'),
          ExperimentACL.new("#{owner}:#{owner}", 'ALL_PERMS')
        ]
      }, owner)

      libid = "#{owner}:LibraryTest#{n}"
      assert DeterLab.create_library(@username, libid, {
        experiments: [ expid1, expid2 ],
        access_lists: [
          LibraryMember.new("#{owner}:#{owner}", 'ALL_PERMS'),
          LibraryMember.new('system:world', 'ALL_PERMS')
        ],
        description: "Test"
      }, owner)

      libs = DeterLab.view_libraries(@username, owner)
      lib  = libs.find { |l| l.libid == libid }

      puts lib.inspect
      assert_equal [ expid1, expid2 ], lib.experiments
    end
  end
end
