module DeterLab

  # Standard DeterLab interface error
  class Error < StandardError; end

  # Not logged in error
  class NotLoggedIn < Error; end

  # General request error (see the message)
  class RequestError < Error; end

  extend DeterLab::Base
  extend DeterLab::ApiInfo
  extend DeterLab::Users
  extend DeterLab::Projects
  extend DeterLab::Circles
  extend DeterLab::Experiments

end
