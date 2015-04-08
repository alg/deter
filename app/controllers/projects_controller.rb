class ProjectsController < ApplicationController

  before_filter :require_login

  # Projects list
  def index
    uid = app_session.current_user_id
    @projects = deter_lab.get_projects.sort do |p1, p2|
      o1 = p1.owner == uid
      o2 = p2.owner == uid

      if o1 == o2
        p1.project_id <=> p2.project_id
      elsif o1
        -1
      else
        1
      end
    end

    gon.getProfileUrl = profile_project_path(':id')
  end

  # project details
  def show
    pid = params[:id]
    @project = get_project(pid)
    if @project.nil?
      redirect_to :projects, alert: t(".not_found")
      return
    end

    @profile = deter_lab.get_project_profile(@project.project_id)
  end

  def manage
    @project = get_project(params[:id])
  end

  # returns project profile
  def profile
    @profile = deter_lab.get_project_profile(params[:id])
    render 'shared/profile'
  end

  # New projects form
  def new
    @profile_descr = deter_lab.get_project_profile_description
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
    deter_lab.invalidate_projects
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    flash.now[:alert] = t(".failure", error: e.message).html_safe
    new
  end

  # Deletes the project
  def destroy
    DeterLab.remove_project(app_session.current_user_id, params[:id])
    deter_lab.invalidate_projects
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    redirect_to :projects, alert: t(".failure", error: e.message).html_safe
  end

  private

  def project_params
    params[:project]
  end

  def get_project(pid)
    deter_lab.get_projects.find { |p| p.project_id == pid }
  end

end
