class DashboardResources

  def initialize(uid, deter_lab)
    @uid = uid
    @d = deter_lab
  end

  def project_experiments
    @d.get_experiments.select { |e| e.id =~ /^[A-Z]/ }
  end

  def accessible_experiments_count
    project_experiments.count
  end

  def member_of_projects_count
    @d.get_projects.count
  end

  def running_experiment_ids
    []
  end

  def owned_project_ids
    @d.get_projects.select { |p| p.owner == @uid }.map(&:project_id)
  end

  def joined_project_ids
    @d.get_projects.select { |p| p.owner != @uid }.map(&:project_id)
  end

  def accessible_library_experiments
    @d.get_experiments.select { |e| e.id !~ /^[A-Z]/ }
  end

  def libraries
    @d.view_libraries
  end

  #
  # Notifications
  #

  def notifications
    @notifications ||= DeterLab.get_notifications(@uid)
  end

  def unread_notifications
    notifications.count { |n| !n.read? }
  end

  def total_notifications
    notifications.size
  end

  def new_project_notifications_count
    notifications.count { |n| n.new_project_request? }
  end

  def join_project_notifications_count
    notifications.count { |n| n.join_project_request? }
  end

end
