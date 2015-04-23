class ExperimentMembersController < ApplicationController

  before_filter :require_login

  # shows the members
  def index
    @experiment = deter_lab.get_experiment(params[:experiment_id])
  end

end
