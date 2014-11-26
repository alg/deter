class ProjectsController < ApplicationController

  before_filter :require_login

  # Projects list
  def index
    @projects = Rails.cache.fetch("deter:user_projects:#{app_session.current_user_id}", expires_in: Rails.env.development? ? 30.minutes : 30.seconds) do
      DeterLab.get_user_projects(app_session.current_user_id)
    end
  end

  # New projects form
  def new
    Rails.cache.delete("deter:project_profile_details")
    @profile_descr = Rails.cache.fetch("deter:project_profile_details", expires_in: Rails.env.test? ? 1.second : 1.day) do
      DeterLab.get_project_profile_description
    end
  end

  # Creates new project
  def create
    # TODO invalidate deter:user_projects:#{app_session.current_user_id}
  end

end
