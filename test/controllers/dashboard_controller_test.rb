require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "blocking non-logged users" do
    get :show
    assert_redirected_to :login
  end

  test "rendering for logged in users" do
    profile = stub("profile", name: "Mark Smith")
    AppSession.new(@controller.session).logged_in_as "mark"
    CachedDeterLab.any_instance.stubs(:get_managed_projects).returns([])
    CachedDeterLab.any_instance.stubs(:get_profile).returns(profile)

    get :show
    assert_response :success
    assert @response.body.match(/User Mark Smith:.*Dashboard/)
  end

end

