module DeterLab
  module Base

    # returns the client instance
    def client(service, uid = nil)
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

    # processes the error and raises the correct exception
    def process_error(e)
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

    # extracts the error code
    def error_code(e)
      deter_fault(e).try(:[], :error_code)
    end

    # extracts the error detail message
    def detail_message(e)
      deter_fault(e).try(:[], :detail_message)
    end

    private

    def deter_fault(e)
      detail  = e.to_hash[:fault][:detail]
      fault   = detail.try(:[], :users_deter_fault)
      fault ||= detail.try(:[], :projects_deter_fault)
      fault.try(:[], :deter_fault)
    end

  end
end
