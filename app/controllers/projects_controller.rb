class ProjectsController < ApplicationController

  before_filter :require_login

  # Projects list
  def index
    @projects = get_projects
    gon.getProfileUrl = profile_project_path(':id')
  end

  # project details
  def show
    pid = params[:id]
    @project = get_projects.find { |p| p.project_id == pid }
    if @project.nil?
      redirect_to :projects, alert: t(".not_found")
      return
    end

    @profile = deter_cache.fetch "project_profile:#{@project.project_id}" do
      DeterLab.get_project_profile(app_session.current_user_id, @project.project_id)
    end
  end

  # returns project profile
  def profile
    @profile = get_project_profile(params[:id])
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

    uid = app_session.current_user_id
    DeterLab.create_project(uid, pp[:name], uid, pp.except(:name))
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

  def get_projects
    deter_cache.fetch "user_projects", 30.minutes do
      DeterLab.view_projects(app_session.current_user_id)
    end
  end

  def get_project_profile(pid)
    deter_cache.fetch "project_profile:#{pid}:#{app_session.current_user_id}", 30.minutes do
      DeterLab.get_project_profile(app_session.current_user_id, pid)
    end
  end

end
