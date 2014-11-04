class AppSession

  def initialize(session)
    @session = session
  end

  # Returns TRUE if the user is currently logged in
  def logged_in?
    uid = @session['user_id']
    uid.present?
  end

  # Remembers logging in
  def logged_in_as(user)
    @session['user_id'] = user
  end

  # Returns the uid of logged in user
  def current_user_id
    @session['user_id']
  end

  # Forgets logging in
  def logged_out
    @session.delete('user_id')
  end

end
