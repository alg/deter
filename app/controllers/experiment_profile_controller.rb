class ExperimentProfileController < ApplicationController

  before_filter :require_login

  # returns experiment profile
  def show
    @profile = deter_lab.get_experiment_profile(params[:id])
    render 'shared/profile'
  end

  # shows the profile edit form
  def edit
    @profile_description = deter_lab.get_experiment_profile_description
    @profile = deter_lab.get_experiment_profile(params[:experiment_id])
    render :edit
  end

  # updates experiment profile data
  def update
    eid = params[:experiment_id]
    res = DeterLab.change_experiment_profile(current_user_id, eid, params[:profile])
    deter_lab.invalidate_experiments

    @errors = res.inject({}) do |m, r|
      m[r[0]] = r[1][:reason] unless r[1][:success]
      m
    end

    if @errors.blank?
      redirect_to manage_experiment_path(eid), notice: t('.success')
    else
      edit
    end
  rescue DeterLab::RequestError => e
    redirect_to experiment_path(eid), alert: t(".failure", error: e.message).html_safe
  end

end
