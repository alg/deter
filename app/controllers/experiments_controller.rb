class ExperimentsController < ApplicationController

  before_filter :require_login

  def index
    @experiments = deter_cache.fetch "user_experiments}", 30.minutes do
      DeterLab.get_user_experiments(app_session.current_user_id)
    end
  end

end
