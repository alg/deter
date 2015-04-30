class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from DeterLab::NotLoggedIn do
    app_session.logged_out
    redirect_to :login
  end

  # Application session wrapper
  def app_session
    @app_session ||= AppSession.new(session)
  end
  helper_method :app_session

  # Returns TRUE if logged in
  def logged_in?
    app_session.logged_in?
  end
  helper_method :logged_in?

  def require_login
    if app_session.logged_in?
      true
    else
      redirect_to :login
    end
  end

  # returns true if the user is in the admin project circle
  def admin?
    app_session.admin?
  end
  helper_method :admin?

  # Returns the instance of cache configured for the current user
  def deter_cache
    @deter_cache ||= DeterCache.new(app_session.current_user_id)
  end

  # returns the cached deter lab access layer
  def deter_lab
    @deter_lab ||= CachedDeterLab.new(deter_cache, app_session.current_user_id)
  end
  helper_method :deter_lab

  # returns the user name
  def current_user_name
    logged_in? ? (deter_lab.get_profile.try(:[], "name") || app_session.current_user_id) : nil
  end
  helper_method :current_user_name
end
