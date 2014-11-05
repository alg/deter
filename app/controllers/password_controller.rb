class PasswordController < ApplicationController

  before_filter :require_login

  def edit
  end

  def update
    @errors = {}
    up = params[:user].permit(:password, :password_confirmation)

    if up[:password] != up[:password_confirmation]
      @errors[:password] = t(".passwords_dont_match")
      render :edit
    else
      if DeterLab.change_password(app_session.current_user_id, up[:password])
        redirect_to :dashboard
      else
        @errors[:password] = t(".failed_to_change")
        render :edit
      end
    end
  end

end
