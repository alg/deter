class DeterCache

  # creates new instance for the user_id
  def initialize(user_id = nil)
    @user_id = user_id
  end

  # fetches data from user cache
  def fetch(scope, expires_in = nil, &block)
    do_fetch key(scope), expires_in, &block
  end

  # fetches data from global cache
  def fetch_global(scope, expires_in = nil, &block)
    do_fetch global_key(scope), expires_in, &block
  end

  # invalidates data in user cache
  def delete(scope)
    do_delete key(scope)
  end

  # invalidates data in global cache
  def delete_global(scope)
    do_delete global_key(scope)
  end

  # invalidates data in global cache
  def delete_matched_global(scope)
    do_delete_matched global_key(scope)
  end

  private

  def do_fetch(k, expires_in, &block)
    if Rails.env.test?
      block.call
    else
      options = {}
      options[:expires_in] = expires_in if !expires_in.nil?
      Rails.cache.fetch(k, options, &block)
    end
  end

  def do_delete(k)
    Rails.cache.delete(k)
  end

  def do_delete_matched(k)
    Rails.cache.delete_matched(k)
  end

  def global_key(scope)
    "deter_lab:#{scope}"
  end

  def key(scope)
    "deter_lab:#{scope}:#{@user_id}"
  end

end
