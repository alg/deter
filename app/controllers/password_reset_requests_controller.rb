class PasswordResetRequestsController < ApplicationController

  # Sends the request to initiate password reset for the
  # given username.
  def create
    if DeterLab.request_password_reset(params[:username], password_reset_url(''))
      redirect_to :root
    else
      render :new
    end
  end

end
