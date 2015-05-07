class ActivityLog

  def initialize(base)
    @key = "activity_log:#{base}"
  end

  # clears the log
  def clear
    REDIS.del @key
  end

  # adds the record to the log
  def add(action, uid = nil, data = nil)
    record = { ts: Time.now.to_i, action: action, uid: uid }
    record.merge!(data) unless data.blank?

    REDIS.lpush @key, record.to_json
  end

  # returns the records (optionally limited)
  def records(max = 0)
    REDIS.lrange(@key, 0, max - 1).map { |r| JSON.parse(r).symbolize_keys }
  end

end
