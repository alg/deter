require 'test_helper'

class ProfileControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "request is redirected to login when session is lost" do
    @controller.deter_lab.expects(:get_profile).raises(DeterLab::NotLoggedIn)
    get :show_my_profile
    assert_redirected_to :login
  end

  test "redirecting to profile on successful update" do
    DeterLab.expects(:change_user_profile).returns(nil)
    @controller.deter_lab.expects(:invalidate_profile)
    put :update, profile: {}
    assert_redirected_to :my_profile
  end

end
