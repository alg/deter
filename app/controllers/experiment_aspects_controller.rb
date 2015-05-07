class ExperimentAspectsController < ApplicationController

  before_filter :require_login
  before_filter :load_experiment
  before_filter :require_owner, only: :destroy

  # edits the aspect
  def edit
    @aspect = @experiment.aspects.find { |a| a.name == params[:id] }
    if @aspect.nil?
      redirect_to experiment_path(@experiment.id), alert: ".not_found"
    end
  end

  # updates the aspect data
  def update
    # @aspect = @experiment.aspects.find { |a| a.name == params[:id] }
    # if @aspect.present?
    #   new_data = params[:aspect][:data]
    #   if @aspect.data != new_data
    #     if DeterLab.update_aspect(current_user_id, @experiment.id, @aspect.name, @aspect.raw_data)

    #     else
    #     end
    #   end
    #   @aspect.xa['change_control_url'] = params[:change_control_url]

    # end

    redirect_to experiment_path(@experiment.id), notice: t(".success")
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
