class WsdlCachingAdapter < HTTPI::Adapter::NetHTTP

  register :wsdl_caching_adapter

  def initialize(request)
    super(request)
    @req = request
  end

  def request(method)
    url = @req.url.to_s
    match = Regexp.new(AppConfig['deter_lab']['wsdl'] % "(.*)\\")
    res = nil

    if reqesting_wsdl = (url =~ Regexp.new(match))
      # wsdl request
      key = "wsdl:#{$1}"
      if Rails.cache.exist?(key)
        raw_body = Rails.cache.read(key)
        res = HTTPI::Response.new(200, {}, raw_body)
      else
        res = super(method)
        unless res.error?
          Rails.cache.write(key, res.raw_body)
        end
      end
    else
      Rails.logger.info "------------- LOGGING ---------------"
      REDIS.lpush("spi_log", { time: Time.now.to_f, type: 'request', xml: @request.body }.to_json)

      # data request
      res = super(method)

      REDIS.lpush("spi_log", { time: Time.now.to_f, type: 'response', xml: res.raw_body }.to_json)
      REDIS.ltrim("spi_log", 0, 99)
    end

    res
  end

  # returns the remote service wsdl url
  def self.service_url(service)
    AppConfig['deter_lab']['wsdl'] % service
  end

end
