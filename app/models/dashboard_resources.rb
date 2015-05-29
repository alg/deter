class DashboardResources

  def initialize(uid)
    @uid = uid
  end

  def accessible_experiments_count
    0
  end

  def member_of_projects_count
    0
  end

  def running_experiment_ids
    []
  end

  def owned_project_ids
    []
  end

  def joined_project_ids
    []
  end

  def accessible_library_experiments
    []
  end

end
