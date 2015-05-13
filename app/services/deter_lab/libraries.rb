module DeterLab
  module Libraries

    # Returns a library profile description
    def get_libraries_profile_description
      get_profile_description("Libraries")
    end

    # Returns the list of user libraries
    def view_libraries(uid, owner = uid)
      cl = client("Libraries", uid)
      response = cl.call(:view_libraries, message: { uid: owner })

      return [response.to_hash[:view_libraries_response][:return] || []].flatten.map do |l|
        members = [ l[:acl] ].flatten.reject(&:blank?).map do |a|
          LibraryMember.new(a[:circle_id], [ a[:permissions] ].flatten)
        end
        Library.new(l[:library_id], l[:owner], l[:perms], [ l[:experiments] ].flatten.reject(&:blank?), members)
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

    # creates the library
    def create_library(uid, name, options = nil, owner = uid)
      options ||= {}
      cl = client("Libraries", uid)

      msg = { libid: name, owner: owner }
      if (acl = options.delete(:access_lists)).present?
        msg[:access_lists] = acl.map do |l|
          { circle_id: l.uid, permissions: l.permissions }
        end
      end

      if (experiments = options.delete(:experiments)).present?
        msg[:eids] = experiments
      end

      if options.present?
        msg[:profile] = options.map { |f, v| { name: f, value: v.to_s } }
      end

      response = cl.call(:create_library, message: msg)

      return response.to_hash[:create_library_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

    # adds experiments to the library
    def add_library_experiments(uid, name, experiment_ids)
      cl = client("Libraries", uid)

      response = cl.call(:add_library_experiments, message: {
        libid: name,
        eids:  experiment_ids
      })

      return [ response.to_hash[:add_library_experiments_response][:return] || [] ].flatten.reject(&:blank?).inject({}) do |m, r|
        m[r[:name]] = r[:success]
        m
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
