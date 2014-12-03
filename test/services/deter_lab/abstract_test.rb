require 'test_helper'

class DeterLab::AbstractTest < ActiveSupport::TestCase

  setup do
    load_user 'general_user'
  end

  protected

  # loads the user name and password for the chosen user
  def load_user(name)
    user = TestsConfig[name]
    @username = user['username']
    @password = user['password']
  end

  # logs the user in
  def login(name = nil)
    load_user(name) if !name.blank?
    skip("Valid test user is missing from tests-config.yml") if @username.blank? or @password.blank?
    assert DeterLab.valid_credentials?(@username, @password)
  end

end
