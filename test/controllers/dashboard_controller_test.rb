require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "blocking non-logged users" do
    get :show
    assert_redirected_to :login
  end

  test "rendering for logged in users" do
    AppSession.new(@controller.session).logged_in_as "mark"
    @controller.deter_lab.stubs(:get_managed_projects).returns([])
    @controller.deter_lab.stubs(:get_profile).returns('name' => 'Mark Smith')
    DeterLab.expects(:get_notifications).returns([])

    get :show
    assert_response :success
    assert @response.body.match(/User <strong>Mark Smith<\/strong>:.*Dashboard/)
  end

end

