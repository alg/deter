class DeterLab

  # Standard DeterLab interface error
  class Error < StandardError; end

  # Not logged in error
  class NotLoggedIn < Error; end

  # General request error (see the message)
  class RequestError < Error; end

  # Returns the current version of the deter lab
  def self.version
    Rails.cache.fetch('deter:version', expires_in: 15.minutes) do
      response = client("ApiInfo").call(:get_version)
      data = response.to_hash[:get_version_response][:return]
      "#{data[:version]}/#{data[:patch_level]}"
    end
  end

  # Checks if there's a user with the given #uid and #password
  def self.valid_credentials?(uid, password)
    cl = client("Users")
    challenge_id = call_request_challenge(cl, uid)
    response = call_challenge_response(cl, challenge_id, password)
    extract_and_store_certs(uid, Base64.decode64(response.to_hash[:challenge_response_response][:return]))

    return true
  rescue Savon::SOAPFault, Error
    return false
  end

  # Logs the user out
  def self.logout(uid)
    cl = client("Users", uid)
    cl.call(:logout)
  rescue Savon::SOAPFault => e
    process_error e
  end

  # Returns a project profile description
  def self.get_project_profile_description
    Rails.cache.fetch("deter:project_profile_description", expires_in: 1.day) do
      cl = client("Projects")
      response = cl.call(:get_profile_description)
      raise Error unless response.success?

      fields = response.to_hash[:get_profile_description_response][:return][:attributes].map do |f|
        ProfileField.new(f[:name], f[:data_type], f[:optional], f[:access], f[:description], f[:format], f[:format_description], f[:length_hint], f[:value])
      end

      ProfileFields.new(fields)
    end
  end

  # Returns a user profile description
  def self.get_user_profile_description
    Rails.cache.fetch("deter:user_profile_description", expires_in: 1.day) do
      cl = client("Users")
      response = cl.call(:get_profile_description)
      raise Error unless response.success?

      fields = response.to_hash[:get_profile_description_response][:return][:attributes].map do |f|
        ProfileField.new(f[:name], f[:data_type], f[:optional], f[:access], f[:description], f[:format], f[:format_description], f[:length_hint], f[:value])
      end

      ProfileFields.new(fields)
    end
  end

  # Returns complete user profile in key-value form
  def self.get_user_profile(uid)
    cl = client("Users", uid)
    response = cl.call(:get_user_profile, "message" => { "uid" => uid })
    raise Error unless response.success?

    return response.to_hash[:get_user_profile_response][:return][:attributes].inject(Profile.new) do |memo, attr|
      memo[attr[:name]] = attr[:value]
      memo
    end
  rescue Savon::SOAPFault => e
    process_error e
  end

  # Changes user profile and returns the list of issues as a hash of field names with error messages.
  def self.change_user_profile(uid, fields)
    changes = fields.map do |k, v|
      { "name" => k, "value" => v, "delete" => 0 }
    end

    cl = client("Users", uid)
    response = cl.call(:change_user_profile, "message" => { "uid" => uid, "changes" => changes })
    raise Error unless response.success?

    return [ response.to_hash[:change_user_profile_response][:return] ].flatten.inject({}) do |m, f|
      m[f[:name]] = f[:reason] if !f[:success]
      m
    end
  rescue Savon::SOAPFault => e
    process_error e
  end

  def self.change_password(uid, new_password)
    cl = client("Users", uid)
    response = cl.call(:change_password, "message" => { "uid" => uid, "newPass" => new_password })
    raise Error unless response.success?

    response.to_hash[:change_password_response][:return]
  rescue Savon::SOAPFault => e
    process_error e
  end

  # Requests the reset of user password. The challenge is sent to the user
  # email address.
  def self.request_password_reset(uid, url_prefix)
    cl = client("Users")
    response = cl.call(:request_password_reset, "message" => { "uid" => uid, "urlPrefix" => url_prefix })
    raise Error unless response.success?

    response.to_hash[:request_password_reset_response][:return]
  rescue Savon::SOAPFault => e
    false
  end

  # Exchange password challenge to change password
  def self.change_password_challenge(challenge, new_pass)
    cl = client("Users")
    response = cl.call(:change_password_challenge, "message" => { "challengeID" => challenge, "newPass" => new_pass })
    raise Error unless response.success?

    response.to_hash[:change_password_challenge_response][:return].inspect
  rescue Savon::SOAPFault => e
    false
  end

  # Returns the list of user projects
  def self.get_user_projects(uid)
    cl = client("Projects", uid)
    response = cl.call(:view_projects, "message" => { "uid" => uid })
    raise Error unless response.success?

    return (response.to_hash[:view_projects_response][:return] || []).map do |p|
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
  def self.create_project(uid, name, project_profile)
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
  def self.remove_project(uid, project_id)
    cl = client("Projects", uid)
    response = cl.call(:remove_project, message: {
      projectid: project_id
    })

    return response.to_hash[:remove_project_response][:return]
  rescue Savon::SOAPFault => e
    process_error e
  end

  # Returns the list of user experiments
  def self.get_user_experiments(uid)
    cl = client("Experiments", uid)
    response = cl.call(:view_experiments, "message" => { "uid" => uid, "listOnly" => true })
    raise Error unless response.success?

    return (response.to_hash[:view_experiments_response][:return] || []).map do |e|
      e
    end
  rescue Savon::SOAPFault => e
    process_error e
  end

  private

  def self.process_error(e)
    code = error_code(e)

    if code == "5"
      raise NotLoggedIn
    elsif code == "2"
      msg = detail_message(e)
      if msg =~ /not logged in/i
        raise NotLoggedIn
      else
        raise RequestError, msg
      end
    else
      if Rails.env.test?
        puts e.to_hash.inspect
      end

      raise Error
    end
  end

  def self.error_code(e)
    deter_fault(e).try(:[], :error_code)
  end

  def self.detail_message(e)
    deter_fault(e).try(:[], :detail_message)
  end

  def self.deter_fault(e)
    detail  = e.to_hash[:fault][:detail]
    fault   = detail.try(:[], :users_deter_fault)
    fault ||= detail.try(:[], :projects_deter_fault)
    fault.try(:[], :deter_fault)
  end

  # extracts certs from the challenge response and stores them for later use
  def self.extract_and_store_certs(uid, x509s)
    cert = x509s.match(/-----BEGIN CERTIFICATE-----.*-----END CERTIFICATE-----/m)[0]
    key  = x509s.match(/-----BEGIN RSA PRIVATE KEY-----.*-----END RSA PRIVATE KEY-----/m)[0]
    raise Error unless cert.present? && key.present?
    SslKeyStorage.put(uid, cert, key)
  end

  # returns challenge ID of the request
  def self.call_request_challenge(cl, user_id)
    response = cl.call(:request_challenge,
      "message" => {
        "uid"   => user_id,
        "types" => "clear",
        :order! => [ :uid, :types ] })

    raise Error unless response.success?

    return response.to_hash[:request_challenge_response][:return][:challenge_id]
  end

  def self.call_challenge_response(cl, challenge_id, password)
    encoded_data = Base64.encode64(password)

    response = cl.call( :challenge_response,
      "message" => {
        "challengeID"  => challenge_id,
        "responseData" => encoded_data,
        :order!        => [ :responseData, :challengeID ] })

    raise Error unless response.success?

    return response
  end

  # Returns the client instance
  def self.client(service, uid = nil)
    options = {
      wsdl:             AppConfig['deter_lab']['wsdl'] % service,
      log_level:        :debug,
      log:              !Rails.env.test?,
      pretty_print_xml: true,
      soap_version:     2,
      namespace:        'http://api.testbed.deterlab.net/xsd',
      logger:           Rails.logger,
      filters:          :password,
      ssl_verify_mode:  :none }

    # optionally user user certs from the storage
    if uid.present?
      cert, key = SslKeyStorage.get(uid)
      if cert.present? && key.present?
        options[:ssl_cert] = OpenSSL::X509::Certificate.new(cert)
        options[:ssl_cert_key] = OpenSSL::PKey.read(key)
      else
        raise Error, "Not logged in as: #{uid}"
      end
    end

    Rails.logger.debug "Savon options: #{options.inspect}"

    Savon.client(options)
  end

end
