module DeterLab
  module Projects

    # Returns a project profile description
    def get_project_profile_description
      get_profile_description("Projects")
    end

    # Returns the list of user projects
    def get_user_projects(uid)
      cl = client("Projects", uid)
      response = cl.call(:view_projects, "message" => { "uid" => uid })

      return [response.to_hash[:view_projects_response][:return] || []].flatten.map do |p|
        members = [ p[:members] ].flatten.map do |m|
          ProjectMember.new(m[:uid], m[:permissions])
        end

        Project.new(p[:project_id], p[:owner], p[:approved], members)
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

    # Creates a project with the given profile for approval.
    # Returns #true if created, or #false if not.
    def create_project(uid, name, project_profile)
      cl = client("Projects", uid)
      response = cl.call(:create_project, message: {
        projectid: name,
        owner: uid,
        profile: project_profile.map { |f, v| {
          name:  f,
          value: v.to_s } }
      })

      raise Error unless response.success?

      return response.to_hash[:create_project_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

    # Deletes the project
    def remove_project(uid, project_id)
      cl = client("Projects", uid)
      response = cl.call(:remove_project, message: {
        projectid: project_id
      })

      return response.to_hash[:remove_project_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
