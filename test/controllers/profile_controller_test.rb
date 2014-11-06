require 'test_helper'

class ProfileControllerTest < ActionController::TestCase

  test "request is redirected to login when session is lost" do
    AppSession.new(@controller.session).logged_in_as "mark"
    @controller.expects(:get_profile).raises(DeterLab::NotLoggedIn)
    get :show
    assert_redirected_to :login
  end

end
