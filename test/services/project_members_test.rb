require 'test_helper'

class ProjectMembersTest < ActiveSupport::TestCase

  test 'successful adding a user' do
    VCR.use_cassette 'tasks/add-user-to-project-success' do
      pid   = 'Alfa-Romeo'
      addee = 'john'
      deter_lab = MiniTest::Mock.new

      aadams = login 'aadams'
      deter_lab.expect(:invalidate_projects, true)
      ProjectMembers.new(aadams, deter_lab, pid).add_user(addee)
      deter_lab.verify

      john = login 'john'
      notifications = DeterLab.get_notifications(john)
      n = notifications.last
      assert n.body =~ /Someone has provisionally added you to project Alfa-Romeo.\n\nThat change will not take effect until you respond to the project challenge/
    end
  end

  test 'failed adding a user' do
    VCR.use_cassette 'tasks/add-user-to-project-failure' do
      pid = 'Devils-Dictionary'

      abierce = login 'abierce'
      err = assert_raise DeterLab::RequestError do
        ProjectMembers.new(abierce, nil, pid).add_user('john')
      end
      assert_equal "Project is not yet approved", err.message
    end
  end

  test 'successful removing users' do
    owner = 'owner'
    pid   = 'pid'
    uid   = 'john'
    deter_lab = MiniTest::Mock.new
    deter_lab.expect(:invalidate_projects, true)
    DeterLab.expects(:remove_users).with(owner, pid, [ uid ]).returns([ { success: true } ])
    ProjectMembers.new(owner, deter_lab, pid).remove_user(uid)
    deter_lab.verify
  end

  test 'failed removing users' do
    owner = 'owner'
    pid   = 'pid'
    uid   = 'john'
    DeterLab.expects(:remove_users).returns([ { success: false, reason: 'error reason' } ])
    err = assert_raise do
      ProjectMembers.new(owner, nil, pid).remove_user(uid)
    end
    assert_equal "error reason", err.message
  end

  private

  def login(name)
    user = TestsConfig[name]
    uid  = user['username']
    pass = user['password']
    assert DeterLab.valid_credentials?(uid, pass)
    uid
  end

end
