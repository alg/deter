class ExperimentMembersController < ApplicationController

  before_filter :require_login
  before_filter :load_experiment
  before_filter :require_owner

  class ExperimentMember < Hashie::Dash
    property :circle_id

    # converts "user" to "user:user", while preserving "group:user"
    def full_circle_id
      if circle_id.present? && !circle_id.match(/^.+:.+$/)
        "#{circle_id}:#{circle_id}"
      else
        circle_id
      end
    end
  end

  # shows the members
  def index
    @new_member = ExperimentMember.new
  end

  # creates a new member record
  def create
    member = ExperimentMember.new(member_params)

    res = DeterLab.change_experiment_acl(@app_session.current_user_id, @experiment.id, [
      ExperimentACL.new(member.full_circle_id, ExperimentACL::ALL_PERMS) ])

    success = res[member.full_circle_id]
    deter_lab.invalidate_experiment(@experiment.id) if success

    options = {}
    options[success ? :notice : :alert] = t(success ? ".success" : ".failure")

    redirect_to experiment_members_path(@experiment.id), options
  end

  # removes the member record
  def destroy
    if params[:id] == "#{@experiment.owner}:#{@experiment.owner}"
      redirect_to experiment_members_path(@experiment.id), alert: t('.deleting_self')
      return
    end

    res = DeterLab.change_experiment_acl(@app_session.current_user_id, @experiment.id, [
      ExperimentACL.new(params[:id], ExperimentACL::DELETE) ])

    success = res[params[:id]]
    deter_lab.invalidate_experiment(@experiment.id) if success

    options = {}
    options[success ? :notice : :alert] = t(success ? ".success" : ".failure")

    redirect_to experiment_members_path(@experiment.id), options
  end

  private

  def load_experiment
    @experiment = deter_lab.get_experiment(params[:experiment_id])
  end

  def require_owner
    unless @experiment.owner == @app_session.current_user_id
      redirect_to experiment_path(params[:experiment_id]), alert: t("experiment_members.owner_only")
    end
  end

  def member_params
    params[:member].permit(:circle_id).symbolize_keys
  end

end
