class ProjectsController < ApplicationController

  before_filter :require_login

  # Projects list
  def index
    @projects = deter_cache.fetch "user_projects", 30.minutes do
      DeterLab.view_projects(app_session.current_user_id)
    end
  end

  # New projects form
  def new
    # deter_cache.delete_global "project_profile_description"
    @profile_descr = deter_cache.fetch_global "project_profile_description", 1.day do
      DeterLab.get_project_profile_description
    end

    render :new
  end

  # Creates new project
  def create
    pp = project_params
    if pp[:name].blank?
      raise DeterLab::RequestError, t(".name_required")
    end

    DeterLab.create_project(app_session.current_user_id, pp.delete(:name), pp)
    deter_cache.delete "user_projects"
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    flash.now[:alert] = t(".failure", error: e.message).html_safe
    new
  end

  # Deletes the project
  def destroy
    DeterLab.remove_project(app_session.current_user_id, params[:id])
    deter_cache.delete "user_projects"
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    redirect_to :projects, alert: t(".failure", error: e.message).html_safe
  end

  private

  def project_params
    params[:project]
  end

end
