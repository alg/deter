class ApplyForAccount

  def self.perform(params)
    case params[:user_type]
    when 'project_leader'
      create_project(params)
    when 'member'
      join_project(params)
    when 'sponsor'
      create_project(params)
    when 'sponsored_student'
      join_project(params)
    when 'educator'
      create_project(params)
    else
      raise "Unknown user type"
    end
  end

  private

  def self.create_project(params)
    user_id = DeterLab.create_user(params[:user])
    pp = params[:project]
    name = pp[:name]
    return DeterLab.create_project(user_id, name, user_id, pp.except(:name))
  end

  def self.join_project(params)
    user_id = DeterLab.create_user(params[:user])
    pp = params[:project]
    name = pp[:name]
    return DeterLab.join_project(user_id, name)
  end

end
