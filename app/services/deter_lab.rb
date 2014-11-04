class DeterLab

  # Standard DeterLab interface error
  class Error < StandardError; end

  # Not logged in error
  class NotLoggedIn < Error; end

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
  end

  # Returns the profile description
  def self.get_profile_description
    Rails.cache.fetch("deter:profile_description", expires_in: 1.day) do
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

  # Returns the list of user projects
  def self.get_user_projects(uid)
    cl = client("Projects", uid)
    response = cl.call(:view_projects, "message" => { "uid" => uid })
    raise Error unless response.success?

    return (response.to_hash[:view_projects_response][:return] || []).map do |p|
      members = p[:members].map do |m|
        ProjectMember.new(m[:uid], m[:permissions])
      end

      Project.new(p[:project_id], p[:owner], p[:approved], members)
    end
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
    error_code = e.to_hash[:fault][:detail].try(:[], :users_deter_fault).try(:[], :deter_fault).try(:[], :error_code)

    if Rails.env.test?
      puts e.to_hash.inspect
    end

    if error_code == "5" # not logged in
      raise NotLoggedIn
    else
      raise Error
    end
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
