class SslKeyStorage

  # Stores the cert and the key
  def self.put(uid, cert, cert_key)
    Rails.cache.write(cache_key(uid), [ cert, cert_key ])
  end

  # Returns [ cert, cert_key ] or nil if the record isn't present
  def self.get(uid)
    Rails.cache.read(cache_key(uid))
  end

  # Deletes the stored certs
  def self.delete(uid)
    Rails.cache.delete(cache_key(uid))
  end

  private

  def self.cache_key(uid)
    "certs:#{uid}"
  end

end
