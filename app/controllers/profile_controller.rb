class ProfileController < ApplicationController

  before_filter :require_login

  # showing user pofile
  def show_my_profile
    show_profile
  end

  # showing profile of a user
  def show
    show_profile(params[:id])
  end

  # editing own profile
  def edit
    @profile = deter_lab.get_profile
    @errors  = {}
  end

  # updating own profile
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

  def show_profile(uid = @app_session.current_user_id)
    @uid     = uid
    @profile = deter_lab.get_profile(uid)
  end

end
