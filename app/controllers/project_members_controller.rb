class ProjectMembersController < ApplicationController

  before_filter :require_login
  before_filter :load_project
  before_filter :require_owner

  # shows the members
  def index
    @new_member = ProjectMember.new
  end

  # creates a new member record
  def create
    options = {}
    AddUserToProject.new(current_user_id, deter_lab).perform(@project.project_id, member_params[:uid])
    options[:notice] = t('.success')
  rescue DeterLab::RequestError => e
    options[:alert] = t('.failure', error: e.message)
  ensure
    redirect_to project_members_path(@project.project_id), options
  end

  # removes the member record
  def destroy
    # member = ExperimentMember.new(circle_id: params[:id])

    # if member.full_circle_id == "#{@experiment.owner}:#{@experiment.owner}"
    #   redirect_to experiment_members_path(@experiment.id), alert: t('.deleting_self')
    #   return
    # end

    # res = DeterLab.change_experiment_acl(@app_session.current_user_id, @experiment.id, [
    #   ExperimentACL.new(member.full_circle_id, ExperimentACL::DELETE) ])

    # success = res[member.full_circle_id]
    # deter_lab.invalidate_experiment(@experiment.id) if success

    options = {}
    # options[success ? :notice : :alert] = t(success ? ".success" : ".failure")

    redirect_to project_members_path(@project.project_id), options
  end

  private

  def load_project
    @project = deter_lab.get_project(params[:project_id])
  end

  def require_owner
    unless @project.owner == current_user_id
      redirect_to project_path(params[:project_id]), alert: t("project_members.owner_only")
    end
  end

  def member_params
    params[:member].permit(:uid).symbolize_keys
  end

end
