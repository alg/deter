class ProfileController < ApplicationController

  before_filter :require_login

  def show
    @profile = Rails.cache.fetch("deter:user_profile:#{app_session.current_user_id}", expires_in: 30.seconds) do
      DeterLab.get_user_profile(app_session.current_user_id)
    end
  end

end
