class ProfileController < ApplicationController

  before_filter :require_login

  def show
    @profile = deter_lab.get_profile
  end

  def edit
    @profile = deter_lab.get_profile
    @errors  = {}
  end

  def update
    @errors = DeterLab.change_user_profile(app_session.current_user_id, form_fields)
    if @errors.blank?
      deter_lab.invalidate_profile
      redirect_to :profile, notice: t(".success")
    else
      @profile = deter_lab.get_profile
      flash.now[:alert] = t(".failure")
      render :edit
    end
  end

  private

  def form_fields
    params[:profile].permit(ProfileFields::FORM_FIELDS)
  end

end
