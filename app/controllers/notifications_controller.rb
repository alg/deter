class NotificationsController < ApplicationController

  before_filter :require_login

  # all notifications list
  def index
    @notifications = get_notifications
    render :all_notifications
  end

  # new notifications list
  def new_only
    @notifications = get_notifications.reject(&:read?)
    render :new_notifications
  end

  private

  def get_notifications
    DeterLab.get_notifications(current_user_id)
  end

end
