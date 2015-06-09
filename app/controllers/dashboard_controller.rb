class DashboardController < ApplicationController

  before_filter :require_login

  # shows user dashboard
  def show
    @notifications = DeterLab.get_notifications(current_user_id)
    gon.resourcesUrl = resources_dashboard_url
  end

  # resources details
  def resources
    @resources = DashboardResources.new(current_user_id, deter_lab)
    render :resources, layout: false
  end

end
