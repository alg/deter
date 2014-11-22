class PasswordResetsController < ApplicationController

  # Sends the request to change the password for the
  # received challenge.
  def create
    password  = params[:password]
    challenge = params[:challenge]

    if password == params[:password_confirmation] &&
       password.present? && challenge.present? &&
       DeterLab.change_password_challenge(challenge, password)
      redirect_to :root
    else
      render :new
    end
  end

end
