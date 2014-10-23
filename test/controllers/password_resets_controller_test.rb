require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

  def setup
    DeterLab.stubs(:version).returns("1.0/0.0")
  end

  test "showing form" do
    get :new
    assert_response :success
  end

  test "resetting password" do
    post :create, challenge: "code", username: "user", password: "pass", password_confirmation: "pass"
    assert_redirected_to :root
  end

end