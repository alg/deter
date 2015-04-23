class ExperimentProfileController < ApplicationController

  before_filter :require_login

  # shows the profile edit form
  def show
    @profile_description = deter_lab.get_experiment_profile_description
    @profile = deter_lab.get_experiment_profile(params[:experiment_id])
  end

end
