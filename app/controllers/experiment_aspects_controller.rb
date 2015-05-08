class ExperimentAspectsController < ApplicationController

  before_filter :require_login
  before_filter :load_experiment
  before_filter :require_owner, only: :destroy

  # edits the aspect
  def edit
    @aspect = @experiment.aspects.find { |a| a.name == params[:id] }
    if @aspect.nil?
      redirect_to experiment_path(@experiment.id), alert: t("experiment_aspects.not_found")
    else
      @change_control_enabled = @aspect.xa['change_control_enabled']
      @change_control_url     = @aspect.xa['change_control_url']
    end
  end

  # updates the aspect data
  def update
    @aspect = @experiment.aspects.find { |a| a.name == params[:id] }
    @change_control_url     = params[:change_control_url]
    @change_control_enabled = params[:change_control_enabled]

    if @aspect.nil?
      redirect_to experiment_path(@experiment.id), alert: t("experiment_aspects.not_found")
    else
      success = false
      new_data = params[:aspect][:data]
      if @aspect.raw_data != new_data
        # res = DeterLab.change_experiment_aspects(current_user_id, @experiment.id, @experiment.aspects)[params[:id]]
        res = { success: true }
        if success = res[:success]
          redirect_to experiment_path(@experiment.id), notice: t(".unimplemented")
        else
          @error = res[:error] || t(".unknown_error")
          render :edit
        end
      else
        success = true
        redirect_to experiment_path(@experiment.id), notice: t(".success")
      end

      if success
        @aspect.xa['change_control_enabled'] = @change_control_enabled
        @aspect.xa['change_control_url']     = @change_control_url
      end
    end
  end

  # removes the member record
  def destroy
    res = DeterLab.remove_experiment_aspects(current_user_id, @experiment.id, [
      { name: params[:id], type: params[:type] }
    ])

    options = {}
    if res[params[:id]]
      options[:notice] = t(".success")
      deter_lab.invalidate_experiment(@experiment.id)
    else
      options[:alert] = t(".failure")
    end

    redirect_to experiment_path(@experiment.id), options
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

end
