class ProjectMembers

  def initialize(current_user_id, deter_lab, project_id)
    @current_user_id = current_user_id
    @deter_lab       = deter_lab
    @project_id      = project_id
  end

  # adds a user to the project
  def add_user(uid)
    res = DeterLab.add_users(@current_user_id, @project_id, [ uid ]).first
    if res[:success]
      @deter_lab.invalidate_projects
    else
      raise DeterLab::RequestError, res[:reason]
    end
  end

  # removes the user from the project
  def remove_user(uid)
    res = DeterLab.remove_users(@current_user_id, @project_id, [ uid ]).first
    if res[:success]
      @deter_lab.invalidate_projects
    else
      raise DeterLab::RequestError, res[:reason]
    end
  end

end
