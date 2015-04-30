class ProjectsController < ApplicationController

  before_filter :require_login

  # Projects list
  def index
    uid = app_session.current_user_id
    projects = SummaryLoader.user_projects(uid).reject { |p| p[:project_id].downcase == 'admin' }

    @approved = projects.select { |p| p[:approved] }.sort do |p1, p2|
      o1 = p1[:leader][:uid] == uid
      o2 = p2[:leader][:uid] == uid

      if o1 == o2
        p1[:project_id] <=> p2[:project_id]
      elsif o1
        -1
      else
        1
      end
    end

    @unapproved = projects.select { |p| !p[:approved] && p[:leader][:uid] == uid }

    gon.getProfileUrl = profile_project_path(':id')
  end

  # project details
  def show
    pid = params[:id]
    @project = get_project(pid)
    if @project.nil?
      redirect_to :projects, alert: t(".not_found")
      return
    end

    @profile = deter_lab.get_project_profile(@project.project_id)

    gon.projectDetailsUrl = details_project_path(pid)
  end

  # renders details about project team and experiments
  # called by JS from the projects/show page
  def details
    pid = params[:id]
    project = get_project(pid)

    @team, members = get_project_member_details(project)
    @experiments   = get_project_experiments_details(pid, members)

    render json: {
      team_html:        render_to_string(partial: "details_team"),
      experiments_html: render_to_string(partial: "details_experiments") }
  end

  def manage
    @project = get_project(params[:id])
  end

  # returns project profile
  def profile
    @profile = deter_lab.get_project_profile(params[:id])
    render 'shared/profile'
  end

  # New projects form
  def new
    @profile_descr = deter_lab.get_project_profile_description
    render :new
  end

  # Creates new project
  def create
    pp = project_params
    if pp[:name].blank?
      raise DeterLab::RequestError, t(".name_required")
    end

    uid = app_session.current_user_id
    DeterLab.create_project(uid, pp[:name], uid, pp.except(:name))
    deter_lab.invalidate_projects
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    flash.now[:alert] = t(".failure", error: e.message).html_safe
    new
  end

  # Deletes the project
  def destroy
    DeterLab.remove_project(app_session.current_user_id, params[:id])
    deter_lab.invalidate_projects
    redirect_to :projects, notice: t(".success")
  rescue DeterLab::RequestError => e
    redirect_to :projects, alert: t(".failure", error: e.message).html_safe
  end

  private

  def project_params
    params[:project]
  end

  def get_project(pid)
    deter_lab.get_projects.find { |p| p.project_id == pid }
  end

  def get_project_experiments_details(pid, members)
    SummaryLoader.project_experiments(deter_cache, @app_session.current_user_id, pid).map do |e|
      { id:     e.id,
        owner:  { id: e.owner, name: members[e.owner]['name'] },
        descr:  deter_lab.get_experiment_profile(e.id)['description'].try(:value),
        status: 'TBD'
      }
    end
  end

  def get_project_member_details(project)
    members = {}

    team = project.members.map do |m|
      profile = SummaryLoader.member_profile(deter_cache, @app_session.current_user_id, m.uid)
      profile['uid'] = m.uid
      profile['leader'] = m.uid == project.owner
      members[m.uid] = profile
      profile
    end

    team.sort! do |m1, m2|
      o1 = m1['leader']
      o2 = m2['leader']

      if o1 == o2
        m1['name'] <=> m2['name']
      elsif o1
        -1
      else
        1
      end
    end

    return [ team, members ]
  end
end
