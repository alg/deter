require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

  test "showing form" do
    get :new, challenge: "some-code"
    assert_response :success
  end

  test "resetting password" do
    DeterLab.expects(:change_password_challenge).with("code", "pass").returns(true)
    post :create, challenge: "code", password: "pass", password_confirmation: "pass"
    assert_redirected_to :root
    assert_equal I18n.t("password_resets.create.success"), flash.notice
  end

  test "failed password reset" do
    DeterLab.expects(:change_password_challenge).returns(false)
    post :create, challenge: "code", password: "pass", password_confirmation: "pass"
    assert_template :new
    assert_equal I18n.t("password_resets.create.failure"), flash.now[:alert]
  end

  test "non-matching passwords" do
    DeterLab.expects(:change_password_challenge).never
    post :create, challenge: "code", password: "1", password_confirmation: "2"
    assert_template :new
  end
end
