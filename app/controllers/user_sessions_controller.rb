class UserSessionsController < ApplicationController

  before_filter :require_login, only: [ :destroy ]

  # Logs the user in
  def create
    username = params[:username].try(:downcase)
    password = params[:password]

    if username.present? && password.present? && DeterLab.valid_credentials?(username, password)
      admin = DeterLab.admin?(username)

      ActivityLog.for_user(username).add(:login, username)

      app_session.logged_in_as(username, admin)
      current_user_session.register_login

      redirect_to :dashboard, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new
    end
  end

  # Logs the user out
  def destroy
    user_id = app_session.current_user_id
    current_user_session.register_logout

    app_session.logged_out
    DeterLab.logout(user_id)
    SslKeyStorage.delete(user_id)

    ActivityLog.for_user(user_id).add(:logout, user_id)
  rescue DeterLab::NotLoggedIn
    # That's ok. We are logging out anyway
  ensure
    redirect_to :login, notice: t(".success")
  end

end
