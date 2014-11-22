require 'test_helper'

class PasswordResetRequestsControllerTest < ActionController::TestCase

  test "showing new request page" do
    get :new
    assert_response :success
  end

  test "submitting valid request" do
    DeterLab.expects(:request_password_reset).returns(true)
    post :create, username: "user"
    assert_redirected_to :root
  end

  test "invalid reset request" do
    DeterLab.expects(:request_password_reset).returns(false)
    post :create, username: "user"
    assert_template :new
  end

end
