class ActivityLog

  def initialize(base)
    @key = "activity_log:#{base}"
  end

  def self.for_user(user_id)
    new("user:#{user_id}")
  end

  def self.for_project(id)
    new("project:#{id}")
  end

  def self.for_experiment(id)
    new("experiment:#{id}")
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
