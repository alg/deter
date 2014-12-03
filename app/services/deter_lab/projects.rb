module DeterLab
  module Projects

    # Returns a project profile description
    def get_project_profile_description
      get_profile_description("Projects")
    end

    # Returns the list of user projects
    def view_projects(uid)
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

    # returns the project profile
    def get_project_profile(uid, pid)
      cl = client("Projects", uid)
      response = cl.call(:get_project_profile, message: { projectid: pid })

      fields = [ response.to_hash[:get_project_profile_response][:return][:attributes] ].flatten.map do |f|
        ProfileField.new(f[:name], f[:data_type], f[:optional], f[:access], f[:description], f[:format], f[:format_description], f[:length_hint], f[:value])
      end

      return ProfileFields.new(fields)
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
