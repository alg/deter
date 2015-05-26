class ExperimentsController < ApplicationController

  before_filter :require_login

  # lists all user experiments
  def index
    uid = app_session.current_user_id
    experiments = SummaryLoader.user_experiments(uid)

    @experiments = experiments.sort do |e1, e2|
      o1 = e1[:owner][:uid] == uid
      o2 = e2[:owner][:uid] == uid
      if o1 == o2
        e1[:id] <=> e2[:id]
      elsif o1
        -1
      else
        1
      end
    end
  end

  # shows experiment details
  def show
    @experiment ||= deter_lab.get_experiment(params[:id])
    if @experiment.nil?
      redirect_to :experiments, alert: t(".not_found")
      return
    end

    @profile = deter_lab.get_experiment_profile(@experiment.id)

    if @experiment.belongs_to_library?
      @profile_descr = deter_lab.get_experiment_profile_description
      @projects      = deter_lab.get_projects.select { |p| p[:approved] && p[:project_id].downcase != 'admin' }
    end

    @realizations = []

    render :show
  end

  # shows the realization page
  def realize
    @experiment = deter_lab.get_experiment(params[:id])
    if @experiment.nil?
      redirect_to :experiments, alert: t(".not_found")
      return
    end

    @visualizations = @experiment.aspects.select do |a|
      a.type == 'visualization' && a.sub_type.blank?
    end

    ActivityLog.for_experiment(@experiment.id).add("realized", current_user_id)
  end

  # opens the management page
  def manage
    @experiment = deter_lab.get_experiment(params[:id])
    if @experiment.nil?
      redirect_to :experiments, alert: t(".not_found")
      return
    end
  end

  # showing the new experiment form
  def new
    @profile_descr = deter_lab.get_experiment_profile_description
    @projects      = deter_lab.get_projects.select { |p| p[:approved] && p[:project_id].downcase != 'admin' }
    render :new
  end

  # creating an experiment
  def create
    create_experiment
    redirect_to :experiments, notice: t(".success")
  rescue DeterLab::RequestError => e
    flash.now[:alert] = t(".failure", error: e.message).html_safe
    new
  end

  # clones an experiment
  def clone
    @experiment = deter_lab.get_experiment(params[:id])
    if @experiment.nil?
      redirect_to :experiments, alert: t(".not_found")
      return
    end

    eid = create_experiment
    copy_aspects(@experiment, eid)
    redirect_to :experiments, notice: t(".success")
  rescue DeterLab::RequestError => e
    flash.now[:alert] = t(".failure", error: e.message).html_safe
    show
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

  # creates an experiment and returns the id
  def create_experiment
    project_id = params[:project_id]
    if project_id.blank?
      raise DeterLab::RequestError, t("experiments.project_id_required")
    end

    name = ep.delete(:name)
    DeterLab.create_experiment(current_user_id, project_id, name, ep)
    deter_lab.invalidate_experiments(project_id)

    eid = "#{project_id}:#{name}"

    # log creation
    log = ActivityLog.for_experiment(eid)
    log.clear
    log.add(:create, current_user_id)

    eid
  end

  # copies aspects from an experiment to the destination
  def copy_aspects(src, dest_eid)
    aspects = src.aspects.reject { |a| !a.root? }.map { |asp| { name: asp.name, type: asp.type, data: asp.raw_data, data_reference: asp.data_reference } }
    if aspects.any?
      res = DeterLab.add_experiment_aspects(current_user_id, dest_eid, aspects)

      # report failures
      failed_aspects = res.select { |k, v| !v }.keys
      if failed_aspects.any?
        raise DeterLab::RequestError, t(".failure", error: t("experiments.errors.copying_aspecs", aspects: failed_aspects.join(", ")))
      end
    end
  end

end
