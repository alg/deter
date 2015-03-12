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

      return [response.to_hash[:view_libraries_response][:return] || []].flatten
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
