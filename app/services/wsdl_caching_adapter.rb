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
      # data request
      res = super(method)
    end

    res
  end

  # returns the remote service wsdl url
  def self.service_url(service)
    AppConfig['deter_lab']['wsdl'] % service
  end

end
