class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Application session wrapper
  def app_session
    Rails.logger.info session['user_id'].inspect
    @app_session ||= AppSession.new(session)
  end
  helper_method :app_session

  def require_login
    if app_session.logged_in?
      true
    else
      redirect_to :login
    end
  end

end
