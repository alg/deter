class ApplyForAccount

  def self.perform(params)
    case params[:user_type]
    when 'project_leader'
      apply_for_project_leader(params)
    else
      false
    end
  end

  private

  def self.apply_for_project_leader(params)
    user_id = DeterLab.create_user(params[:user])

    pp = params[:project]
    name = pp[:name]
    return DeterLab.create_project(nil, name, user_id, pp.except(:name))
  end

  # returns user ID or raises an exception
  def self.create_user(user_params)
  end
end