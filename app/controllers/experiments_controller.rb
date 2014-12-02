class ExperimentsController < ApplicationController

  before_filter :require_login

  def index
    @experiments = get_experiments
  end

  def show
    @experiment = get_experiments.find { |ex| ex.name == params[:id] }
    if @experiment.nil?
      redirect_to :experiments, alert: t(".not_found")
    end
  end

  private

  def get_experiments
    return deter_cache.fetch "user_experiments", 30.minutes do
      DeterLab.get_user_experiments(app_session.current_user_id)
    end
  end

end
