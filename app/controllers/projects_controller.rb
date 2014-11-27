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

    render :new
  end

  # Creates new project
  def create
    pp = project_params
    if pp[:name].blank?
      raise DeterLab::RequestError, t(".name_required")
    end

    DeterLab.create_project(app_session.current_user_id, pp.delete(:name), pp)
    invalidate_projects_cache
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    flash.now[:alert] = t(".failure", error: e.message).html_safe
    new
  end

  # Deletes the project
  def destroy
    DeterLab.remove_project(app_session.current_user_id, params[:id])
    invalidate_projects_cache
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    redirect_to :projects, alert: t(".failure", error: e.message).html_safe
  end

  private

  def project_params
    params[:project]
  end

  def invalidate_projects_cache
    Rails.cache.delete("deter:user_projects:#{app_session.current_user_id}")
  end

end
