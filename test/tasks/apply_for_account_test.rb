require 'test_helper'

class ApplyForAccountTest < ActiveSupport::TestCase

  test "applying for research group leader account" do
    DeterLab.expects(:create_user).with(:up).returns("mark")
    DeterLab.expects(:create_project).with(nil, "name", "mark", {}).returns(true)

    assert ApplyForAccount.perform({
      user_type:  'project_leader',
      user:       :up,
      project:    { name: 'name' }
    })
  end

  test "applying for research group leader account fails" do
    DeterLab.expects(:create_user).raises(DeterLab::RequestError.new("error-message"))

    ex = assert_raise DeterLab::RequestError do
      ApplyForAccount.perform({
        user_type: 'project_leader',
        user: {},
        project: {}
      })
    end
    assert_equal 'error-message', ex.message
  end

  test "applying for resarch member account" do
  end

  test "applying for reseach advisor account" do
  end

  test "applying for student account" do
  end

  test "applying for staff account" do
  end

end
