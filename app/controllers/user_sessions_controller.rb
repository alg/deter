class UserSessionsController < ApplicationController

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
    app_session.logged_out
    redirect_to :login
  end

end
