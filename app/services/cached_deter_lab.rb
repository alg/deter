class CachedDeterLab

  # creates the deter_lab with cached layer
  def initialize(deter_cache, uid)
    @deter_cache = deter_cache
    @current_uid = uid
  end

  # -----------------------------------------------------------------------------------------------
  # Profile
  # -----------------------------------------------------------------------------------------------

  # returns user profile
  def get_profile(uid = @current_uid)
    @deter_cache.fetch_global "profile:#{uid}", 30.seconds do
      DeterLab.get_user_profile(@current_uid, uid)
    end
  end

  # invalidates user profile
  def invalidate_profile
    @deter_cache.delete "profile"
  end

  # -----------------------------------------------------------------------------------------------
  # Projects
  # -----------------------------------------------------------------------------------------------

  # returns the list of projects for the user
  def get_projects
    @deter_cache.fetch "projects", 30.minutes do
      DeterLab.view_projects(@current_uid)
    end
  end

  # the list of projects managed by this user directly
  def get_managed_projects
    get_projects.select { |p| p.owner == @current_uid }
  end

  # invalidates the user projects cache
  def invalidate_projects
    @deter_cache.delete "projects"
    @deter_cache.delete "projects_summary"
  end

  # returns the project profile
  def get_project_profile(pid)
    @deter_cache.fetch "project_profile:#{pid}", 30.minutes do
      DeterLab.get_project_profile(@current_uid, pid)
    end
  end

  # returns the project profile description
  def get_project_profile_description
    @deter_cache.fetch_global "project_profile_description", 1.day do
      DeterLab.get_project_profile_description
    end
  end

  # -----------------------------------------------------------------------------------------------
  # Libraries
  # -----------------------------------------------------------------------------------------------

  # returns the list of libraries
  def view_libraries
    @deter_cache.fetch "libraries", 30.minutes do
      DeterLab.view_libraries(@current_uid)
    end
  end

  # returns library profile description
  def get_library_profile_description
    @deter_cache.fetch_global "library_profile_description", 1.day do
      DeterLab.get_library_profile_description
    end
  end

  # invalidates libraries
  def invalidate_libraries
    @deter_cache.delete_matched_global "libraries:*"
    @deter_cache.delete_matched_global "libraries_summary:*"
  end

  # -----------------------------------------------------------------------------------------------
  # Experiments
  # -----------------------------------------------------------------------------------------------

  # returns user experiments
  def get_experiments
    @deter_cache.fetch "experiments", 30.minutes do
      DeterLab.view_experiments(@current_uid)
    end
  end

  # invalidates user experiments
  def invalidate_experiments(project_id = nil)
    @deter_cache.delete "experiments"
    @deter_cache.delete "experiments_summary"

    if project_id.nil?
      @deter_cache.delete_matched_global "project:*:experiments"
      @deter_cache.delete_matched_global "experiment:*"
    else
      @deter_cache.delete_global "project:#{project_id}:experiments"
      @deter_cache.delete_matched_global "experiment:#{project_id}:*"
    end
  end

  # returns experiment data
  def get_experiment(eid)
    @deter_cache.fetch_global "experiment:#{eid}", 30.minutes do
      DeterLab.view_experiments(@current_uid, list_only: false, regex: eid, query_aspects: { }).first
    end
  end

  # invalidates the experiment cache
  def invalidate_experiment(eid)
    @deter_cache.delete_global "experiment:#{eid}"
  end

  # returns experiment profile
  def get_experiment_profile(eid)
    @deter_cache.fetch "experiment_profile:#{eid}" do
      DeterLab.get_experiment_profile(@current_uid, eid)
    end
  end

  # returns experiment profile description
  def get_experiment_profile_description
    @deter_cache.fetch_global "experiment_profile_description", 1.day do
      DeterLab.get_experiment_profile_description
    end
  end
end
