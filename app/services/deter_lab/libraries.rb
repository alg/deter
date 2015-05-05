module DeterLab
  module Libraries

    # Returns a library profile description
    def get_libraries_profile_description
      get_profile_description("Libraries")
    end

    # Returns the list of user libraries
    def view_libraries(uid)
      cl = client("Libraries", uid)
      response = cl.call(:view_libraries, message: { uid: uid })

      return [response.to_hash[:view_libraries_response][:return] || []].flatten.map do |l|
        members = [ l[:acl] ].flatten.reject(&:blank?).map do |a|
          LibraryMember.new(a[:circle_id], [ a[:permissions] ].flatten)
        end
        Library.new(l[:library_id], l[:owner], l[:perms], l[:experiments] || [], members)
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

    # creates the library
    def create_library(uid, name, options = nil)
      options ||= {}
      cl = client("Libraries", uid)

      msg = { libid: name, owner: uid }
      if (acl = options.delete(:access_lists)).present?
        msg[:access_lists] = acl.map do |l|
          { circle_id: l.uid, permissions: l.permissions }
        end
      end

      if options.present?
        msg[:profile] = options.map { |f, v| { name: f, value: v.to_s } }
      end

      response = cl.call(:create_library, message: msg)

      return response.to_hash[:create_library_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
