require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "blocking non-logged users" do
    get :show
    assert_redirected_to :login
  end

  test "rendering for logged in users" do
    AppSession.new(@controller.session).logged_in_as "mark"
    CachedDeterLab.any_instance.stubs(:get_managed_projects).returns([])

    get :show
    assert_response :success
    assert @response.body.match(/Logged in as mark/)
  end

end

