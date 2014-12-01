module DeterLab
  module ApiInfo

    # Returns the current version of the deter lab
    def version
      DeterCache.new.fetch_global "version", 15.minutes do
        response = client("ApiInfo").call(:get_version)
        data = response.to_hash[:get_version_response][:return]
        "#{data[:version]}/#{data[:patch_level]}"
      end
    end

  end
end
