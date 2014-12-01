require 'test_helper'

class CirclesControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "listing circles" do
    get :index
    assert_not_nil assigns[:circles]
  end

end
