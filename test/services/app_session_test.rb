require 'test_helper'

class AppSessionTest < ActiveSupport::TestCase

  setup do
    @session = {}
    @app_session = AppSession.new(@session)
  end

  test "initially logged out" do
    assert !@app_session.logged_in?
    assert_nil @app_session.current_user_id
  end

  test "remembering logging in" do
    @app_session.logged_in_as("user")
    assert @app_session.logged_in?
    assert_equal @app_session.current_user_id, "user"
  end

  test "remembering logging out" do
    @app_session.logged_in_as "user"
    @app_session.logged_out
    assert !@app_session.logged_in?
    assert_nil @app_session.current_user_id
  end

end

