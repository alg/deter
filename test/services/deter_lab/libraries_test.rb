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

      # create library
      n = 1
      libid = "#{@username}:Library3Test#{n}"
      assert DeterLab.create_library(@username, libid, {
        description: "Test"
      })

      list = DeterLab.view_libraries(@username)
      assert_not_nil list.find { |l| l.libid == libid }
    end
  end

  test "creating library" do
    VCR.use_cassette "deterlab/libraries/create-library" do
      login 'admin_user'

      n = 1
      owner = "john"
      libid = "#{owner}:LibraryTest#{n}"
      assert DeterLab.create_library(@username, libid, {
        access_lists: [
          LibraryMember.new("#{owner}:#{owner}", 'ALL_PERMS'),
          LibraryMember.new('system:world', 'ALL_PERMS')
        ],
        description: "Test"
      }, owner)

      libs = DeterLab.view_libraries(@username, owner)
      lib  = libs.find { |l| l.libid == libid }
      assert_not_nil lib
    end
  end

  test "add library experiments" do
    VCR.use_cassette "deterlab/libraries/add-library-experiments" do
      login 'admin_user'

      n = 2
      owner = "john"

      # create experiment 1
      ename = "HelloWorld1#{n}"
      expid1 = "#{owner}:#{ename}"
      assert DeterLab.create_experiment(@username, owner, ename, {
        description: "Test library exp",
        access_lists: [
          ExperimentACL.new('system:world', 'ALL_PERMS'),
          ExperimentACL.new("#{owner}:#{owner}", 'ALL_PERMS')
        ]
      }, owner)

      # create experiment 2
      ename = "HelloWorld2#{n}"
      expid2 = "#{owner}:#{ename}"
      assert DeterLab.create_experiment(@username, owner, ename, {
        description: "Test library exp",
        access_lists: [
          ExperimentACL.new('system:world', 'ALL_PERMS'),
          ExperimentACL.new("#{owner}:#{owner}", 'ALL_PERMS')
        ]
      }, owner)

      # create library
      libid = "#{owner}:Library2Test#{n}"
      assert DeterLab.create_library(@username, libid, {
        access_lists: [
          LibraryMember.new("#{owner}:#{owner}", 'ALL_PERMS'),
          LibraryMember.new('system:world', 'ALL_PERMS')
        ],
        description: "Test"
      }, owner)

      # add experiment to a library
      assert_equal({ expid1 => true, expid2 => true }, DeterLab.add_library_experiments(@username, libid, [ expid1, expid2 ]))
    end
  end
end
