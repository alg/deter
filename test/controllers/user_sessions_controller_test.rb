require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  test "shows login page" do
    get :new
    assert_select 'h1', 'Welcome to DeterLab'
  end

  test "logs in as a user" do
    DeterLab.stubs(:valid_credentials?).returns(true)
    @app_session = AppSession.new(@controller.session)

    post :create, username: 'user_id', password: 'pass'
    assert_redirected_to :dashboard
    assert_equal I18n.t("user_sessions.create.success"), flash.notice
    assert @app_session.logged_in?
  end

  test "doesn't login" do
    DeterLab.stubs(:valid_credentials?).returns(false)

    post :create, uid: 'user_id', password: 'pass'
    assert_equal I18n.t("user_sessions.create.failure"), flash.now[:alert]
    assert_template :new
  end

  test "logging out" do
    DeterLab.stubs(:logout).returns(true)

    @app_session = AppSession.new(@controller.session)
    @app_session.logged_in_as "user"

    delete :destroy
    assert_equal I18n.t("user_sessions.destroy.success"), flash.notice
    assert_redirected_to :login

    assert !@app_session.logged_in?
  end

  test "logging out when session is lost" do
    DeterLab.expects(:logout).raises(DeterLab::NotLoggedIn)

    @app_session = AppSession.new(@controller.session)
    @app_session.logged_in_as "user"

    delete :destroy
    assert_redirected_to :login

    assert !@app_session.logged_in?
  end
end
