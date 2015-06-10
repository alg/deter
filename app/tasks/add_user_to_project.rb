class AddUserToProject

  def initialize(current_user_id, deter_lab)
    @current_user_id = current_user_id
    @deter_lab       = deter_lab
  end

  # adds a user to the project
  def perform(pid, uid)
    res = DeterLab.add_users(@current_user_id, pid, [ uid ])
    if res[:success]
      @deter_lab.invalidate_projects
    else
      raise DeterLab::RequestError, res[:reason]
    end
  end

end
