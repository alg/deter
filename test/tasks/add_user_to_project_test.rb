require 'test_helper'

class AddUserToProjectTest < ActiveSupport::TestCase

  test 'successful adding a user' do
    VCR.use_cassette 'tasks/add-user-to-project-success' do
      pid   = 'Alfa-Romeo'
      addee = 'john'
      deter_lab = MiniTest::Mock.new

      aadams = login 'aadams'
      deter_lab.expect(:invalidate_projects, true)
      AddUserToProject.new(aadams, deter_lab).perform(pid, addee)
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
        AddUserToProject.new(abierce, nil).perform(pid, 'john')
      end
      assert_equal "Project is not yet approved", err.message
    end
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
