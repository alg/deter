class ExperimentsController < ApplicationController

  before_filter :require_login

  # lists all user experiments
  def index
    uid = app_session.current_user_id
    @experiments = deter_lab.get_experiments.sort do |e1, e2|
      o1 = e1.owner == uid
      o2 = e2.owner == uid
      if o1 == o2
        e1.id <=> e2.id
      elsif o1
        -1
      else
        1
      end
    end

    gon.getProfileUrl = profile_experiment_path(':id')
  end

  # shows experiment details
  def show
    @experiment = deter_lab.get_experiment(params[:id])
    if @experiment.nil?
      redirect_to :experiments, alert: t(".not_found")
      return
    end

    @profile = deter_lab.get_experiment_profile(@experiment.id)
  end

  # returns experiment profile
  def profile
    @profile = deter_lab.get_experiment_profile(params[:id])
    render 'shared/profile'
  end

  # runs the experiment
  def run
    uid = @app_session.current_user_id
    DeterLab.realize_experiment(uid, uid, params[:id])
    redirect_to :experiments, notice: t(".success")
  rescue DeterLab::RequestError => e
    redirect_to :experiments, alert: t(".failure", error: e.message).html_safe
  end

  # showing the new experiment form
  def new
    @profile_descr = deter_lab.get_experiment_profile_description
    @projects      = deter_lab.get_projects
    render :new
  end

  # creating an experiment
  def create
    project_id = params[:project_id]
    if project_id.blank?
      raise DeterLab::RequestError, t(".project_id_required")
    end

    DeterLab.create_experiment(app_session.current_user_id, project_id, ep.delete(:name), ep)
    deter_lab.invalidate_experiments(project_id)
    redirect_to :experiments, notice: t(".success")
  rescue DeterLab::RequestError => e
    flash.now[:alert] = t(".failure", error: e.message).html_safe
    new
  end

  # deletes the experiment
  def destroy
    DeterLab.remove_experiment(app_session.current_user_id, params[:id])
    deter_lab.invalidate_experiments
    redirect_to :experiments, notice: t(".success")
  rescue DeterLab::RequestError => e
    redirect_to :experiments, alert: t(".failure", error: e.message).html_safe
  end

  private

  def ep
    params[:experiment]
  end

end
