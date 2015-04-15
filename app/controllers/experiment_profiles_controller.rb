class ExperimentProfilesController < ApplicationController

  before_filter :require_login

  # shows the profile edit form
  def edit
    @profile_description = deter_lab.get_experiment_profile_description
    @profile = deter_lab.get_experiment_profile(params[:id])
  end

end
