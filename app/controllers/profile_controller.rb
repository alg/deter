class ProfileController < ApplicationController

  before_filter :require_login

  def show
    @profile = get_profile
  end

  def edit
    @profile = get_profile
    @errors  = {}
  end

  def update
    @errors = DeterLab.change_user_profile(app_session.current_user_id, form_fields)
    if @errors.blank?
      invalidate_cache
      redirect_to :profile, notice: t(".success")
    else
      @profile = get_profile
      flash.now[:alert] = t(".failure")
      render :edit
    end
  end

  private

  def cache_key
    "deter:user_profile:#{app_session.current_user_id}""deter:user_profile:#{app_session.current_user_id}"
  end

  def get_profile
    Rails.cache.fetch(cache_key, expires_in: 30.seconds) do
      DeterLab.get_user_profile(app_session.current_user_id)
    end
  end

  def invalidate_cache
    Rails.cache.delete(cache_key)
  end

  def form_fields
    params[:profile].permit(ProfileFields::FORM_FIELDS)
  end

end
