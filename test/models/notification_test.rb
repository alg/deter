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

end
