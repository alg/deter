class DashboardController < ApplicationController

  before_filter :require_login

  # shows user dashboard
  def show
    @notifications = DeterLab.get_notifications(current_user_id)
  end

end
