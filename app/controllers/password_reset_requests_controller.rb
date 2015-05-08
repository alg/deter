class PasswordResetRequestsController < ApplicationController

  # Sends the request to initiate password reset for the
  # given username.
  def create
    username = params[:username]
    if username.present? && DeterLab.request_password_reset(username, password_reset_with_challenge_url(challenge: ''))
      redirect_to :root, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new
    end
  end

end
