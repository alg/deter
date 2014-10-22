class DeterLab

  # Returns the current version of the deter lab
  def self.version
    Rails.cache.fetch('deterlab.version', expires_in: 15.minutes) do
      response = client.call(:get_version)
      data = response.to_hash[:get_version_response][:return]
      "#{data[:version]}/#{data[:patch_level]}"
    end
  end

  private

  # Returns the client instance
  def self.client
    @client ||= Savon.client(
      wsdl:             AppConfig['deter_lab']['wsdl'],
      log_level:        :debug,
      log:              !Rails.env.test?,
      pretty_print_xml: true,
      soap_version:     2,
      namespace:        'http://api.testbed.deterlab.net/xsd',
      logger:           Rails.logger,
      filters:          :password,
      ssl_verify_mode:  :none)
  end

end
