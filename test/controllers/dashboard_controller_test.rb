require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "blocking non-logged users" do
    get :show
    assert_redirected_to :login
  end

  test "rendering for logged in users" do
    AppSession.new(@controller.session).logged_in_as "mark"

    get :show
    assert_response :success
    assert @response.body.match(/Logged in as mark/)
  end

end

