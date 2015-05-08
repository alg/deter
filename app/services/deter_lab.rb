module DeterLab

  # Standard DeterLab interface error
  class Error < StandardError; end

  # Unimplemented
  class Unimplemented < Error; end

  # Not logged in error
  class NotLoggedIn < Error; end

  # General request error (see the message)
  class RequestError < Error; end

  # Access denied error
  class AccessDenied < Error; end

  extend DeterLab::Base
  extend DeterLab::ApiInfo
  extend DeterLab::Users
  extend DeterLab::Notifications
  extend DeterLab::Projects
  extend DeterLab::Circles
  extend DeterLab::Experiments
  extend DeterLab::Libraries

end
