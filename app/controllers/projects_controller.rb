class ProjectsController < ApplicationController

  before_filter :require_login

  def index
    @projects = Rails.cache.fetch("deter:user_projects:#{app_session.current_user_id}", expires_in: Rails.env.development? ? 30.minutes : 30.seconds) do
      DeterLab.get_user_projects(app_session.current_user_id)
    end
  end

end
