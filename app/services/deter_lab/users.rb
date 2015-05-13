module DeterLab
  module Users

    # Checks if there's a user with the given #uid and #password
    def valid_credentials?(uid, password)
      cl = client("Users")
      challenge_id = call_request_challenge(cl, uid)
      response = call_challenge_response(cl, challenge_id, password)
      extract_and_store_certs(uid, Base64.decode64(response.to_hash[:challenge_response_response][:return]))

      return true
    rescue Savon::SOAPFault, Error
      return false
    end

    # true if the user is in the admin project circle
    def admin?(uid)
      circle = DeterLab.view_circles(uid, "admin:admin").first
      return circle && !circle.members.find { |m| m.uid == uid }.nil?
    rescue DeterLab::AccessDenied
      return false
    end

    # Logs the user out
    def logout(uid)
      cl = client("Users", uid)
      cl.call(:logout)
    rescue Savon::SOAPFault => e
      process_error e
    end

    # Returns a user profile description
    def get_user_profile_description
      get_profile_description("Users")
    end

    # Returns complete user profile in key-value form
    def get_user_profile(uid, user_id = uid)
      if user_id == "system"
        profile = Profile.new
        profile["name"] = "World"
        return profile
      end

      cl = client("Users", uid)
      response = cl.call(:get_user_profile, "message" => { "uid" => user_id })
      raise Error unless response.success?

      return response.to_hash[:get_user_profile_response][:return][:attributes].inject(Profile.new) do |memo, attr|
        memo[attr[:name]] = attr[:value]
        memo
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

    # Changes user profile and returns the list of issues as a hash of field names with error messages.
    def change_user_profile(uid, fields)
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

    def change_password(uid, new_password)
      cl = client("Users", uid)
      response = cl.call(:change_password, "message" => { "uid" => uid, "newPass" => new_password })
      raise Error unless response.success?

      response.to_hash[:change_password_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

    # Requests the reset of user password. The challenge is sent to the user
    # email address.
    def request_password_reset(uid, url_prefix)
      cl = client("Users")
      response = cl.call(:request_password_reset, "message" => { "uid" => uid, "urlPrefix" => url_prefix })
      raise Error unless response.success?

      response.to_hash[:request_password_reset_response][:return]
    rescue Savon::SOAPFault => e
      false
    end

    # Exchange password challenge to change password
    def change_password_challenge(challenge, new_pass)
      cl = client("Users")
      response = cl.call(:change_password_challenge, "message" => { "challengeID" => challenge, "newPass" => new_pass })

      response.to_hash[:change_password_challenge_response][:return]
    rescue Savon::SOAPFault => e
      false
    end

    # creates a user and returns the userid
    def create_user(profile)
      cl = client("Users")
      response = cl.call(:create_user, message: {
        profile: profile.map { |k, v| { name: k, value: v.to_s } }
      })

      res = response.to_hash[:create_user_response][:return]
      extract_and_store_certs(res[:uid], Base64.decode64(res[:identity]))
      return res[:uid]
    rescue Savon::SOAPFault => e
      process_error e
    end

    # creates a user without confirmation
    def create_user_no_confirm(uid, password, profile)
      cl = client("Users", uid)
      response = cl.call(:create_user_no_confirm, message: {
        profile: profile.map { |k, v| { name: k, value: v.to_s } },
        clearpassword: password
      })

      res = response.to_hash[:create_user_no_confirm_response][:return]
      return res
    rescue Savon::SOAPFault => e
      process_error e
    end

    private

    # extracts certs from the challenge response and stores them for later use
    def extract_and_store_certs(uid, x509s)
      cert = x509s.match(/-----BEGIN CERTIFICATE-----.*-----END CERTIFICATE-----/m)[0]
      key  = x509s.match(/-----BEGIN RSA PRIVATE KEY-----.*-----END RSA PRIVATE KEY-----/m)[0]
      raise Error unless cert.present? && key.present?
      SslKeyStorage.put(uid, cert, key)
    end

    # returns challenge ID of the request
    def call_request_challenge(cl, user_id)
      response = cl.call(:request_challenge,
        "message" => {
          "uid"   => user_id,
          "types" => "clear",
          :order! => [ :uid, :types ] })

      raise Error unless response.success?

      return response.to_hash[:request_challenge_response][:return][:challenge_id]
    end

    def call_challenge_response(cl, challenge_id, password)
      encoded_data = Base64.encode64(password)

      response = cl.call( :challenge_response,
        "message" => {
          "challengeID"  => challenge_id,
          "responseData" => encoded_data,
          :order!        => [ :responseData, :challengeID ] })

      raise Error unless response.success?

      return response
    end

  end
end
