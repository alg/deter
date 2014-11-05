require 'test_helper'

class PasswordControllerTest < ActionController::TestCase

  def setup
    DeterLab.stubs(:version).returns("1.0/0.0")
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "showing change password form" do
    get :edit
    assert_response :success
  end

  test "successful password change" do
    DeterLab.stubs(:change_password).returns(true)
    post :update, user: { password: "abc", password_confirmation: "abc" }
    assert_redirected_to :dashboard
  end

  test "failed password change" do
    DeterLab.stubs(:change_password).returns(false)
    post :update, user: { password: "", password_confirmation: "" }
    assert_template :edit
    assert_equal I18n.t("password.update.failed_to_change"), assigns(:errors)[:password]
  end

  test "non-matching passwords" do
    post :update, user: { password: "1", password_confirmation: "2" }
    assert_template :edit
    assert_equal I18n.t("password.update.passwords_dont_match"), assigns(:errors)[:password]
  end

end
