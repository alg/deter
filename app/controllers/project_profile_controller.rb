class ProjectProfileController < ApplicationController

  before_filter :require_login

  # shows the profile edit form
  def edit
    @profile_description = deter_lab.get_project_profile_description
    @profile = deter_lab.get_project_profile(params[:project_id])
    render :edit
  end

  # updates project profile data
  def update
    res = DeterLab.change_project_profile(current_user_id, params[:project_id], params[:profile])
    deter_lab.invalidate_projects

    @errors = res.inject({}) do |m, r|
      m[r[0]] = r[1][:reason] unless r[1][:success]
      m
    end

    if @errors.blank?
      redirect_to manage_project_path(params[:project_id]), notice: t('.success')
    else
      edit
    end
  rescue DeterLab::RequestError => e
    redirect_to project_path(params[:project_id]), alert: t(".failure", error: e.message).html_safe
  end

end
