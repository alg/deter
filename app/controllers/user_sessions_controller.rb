class UserSessionsController < ApplicationController

  before_filter :require_login, only: [ :destroy ]

  def new
  end

  def create
    if DeterLab.valid_credentials?(params[:username], params[:password])
      app_session.logged_in_as(params[:username])

      redirect_to :dashboard
    else
      redirect_to :login
    end
  end

  def destroy
    SslKeyStorage.delete(app_session.current_user_id)
    DeterLab.logout(app_session.current_user_id)

    app_session.logged_out
    redirect_to :login
  end

end
