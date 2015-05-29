class UserSession

  include Concerns::WithExtendedAttributes

  def initialize(uid)
    @uid = uid
  end

  # extended attributes key
  def xa_key
    unless defined? @xa_key
      @xa_key = "user:#{@uid}"
    end
    @xa_key
  end

  # number of logins
  def login_count
    self.xa['login_count'] || 0
  end

  # true if this is the first login
  def first_login?
    login_count <= 1
  end

  # registers the login
  def register_login
    self.xa['last_login_at'] = self.xa['new_login_at']
    self.xa['new_login_at']  = Time.now.to_f.to_s
    inc_login_count
  end

  # registers the logout
  def register_logout
    self.xa['last_logout_at'] = Time.now.to_f.to_s
  end

  # timestamp of the last login or nil
  def last_login_at
    v = self.xa['last_login_at']
    v.present? ? Time.at(v.to_f) : nil
  end

  # timestamp of the last logout or nil
  def last_logout_at
    v = self.xa['last_logout_at']
    v.present? ? Time.at(v.to_f) : nil
  end

  private

  def inc_login_count
    self.xa['login_count'] = login_count + 1
  end

end
