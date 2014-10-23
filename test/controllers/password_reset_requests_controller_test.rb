require 'test_helper'

class PasswordResetRequestsControllerTest < ActionController::TestCase

  def setup
    DeterLab.stubs(:version).returns("1.0/0.0")
  end

  test "showing new request page" do
    get :new
    assert_response :success
  end

  test "submitting the request" do
    post :create, username: "user"
    assert_redirected_to :root
  end

end
