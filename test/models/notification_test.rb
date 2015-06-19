require 'test_helper'

class NotificationTest < ActiveSupport::TestCase

  test "urgent flag" do
    assert !Notification.new(nil, nil, [ { tag: "URGENT", is_set: false } ], nil).urgent?
    assert Notification.new(nil, nil, [ { tag: "URGENT", is_set: true } ], nil).urgent?
  end

  test "read flag" do
    assert !Notification.new(nil, nil, [ { tag: "READ", is_set: false } ], nil).read?
    assert Notification.new(nil, nil, [ { tag: "READ", is_set: true } ], nil).read?
  end

  test "formatted sent at" do
    assert_equal "2015-05-04 5:47pm", Notification.new(nil, nil, [], "20150504T174720Z").sent_on_formatted
  end

  test "join project request" do
    text = "aackermann has asked to join your project Alfa-Romeo. That change will not take effect until you respond to the project challenge -4936889053604975600"
    n = Notification.new(nil, text, [], true)

    assert       n.join_project_request?
    assert_not   n.new_project_request?
    assert_equal "aackermann", n.user
    assert_equal "Alfa-Romeo", n.project_id
    assert_equal "-4936889053604975600", n.challenge
  end

  test "new project request" do
    text = "abierce has created a new project Devils-Dictionary. That project will not be active until someone approves it. You have the authority to do so."
    n = Notification.new(nil, text, [], true)

    assert_not   n.join_project_request?
    assert       n.new_project_request?
    assert_equal "abierce", n.user
    assert_equal "Devils-Dictionary", n.project_id
  end

end
