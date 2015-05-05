class NotificationsController < ApplicationController

  before_filter :require_login

  # new notifications list
  def index
    @notifications = get_notifications
    render :new_notifications
  end

  # current notifications list
  def current
    @notifications = get_notifications
    render :current_notifications
  end

  # the list of archived notifications
  def archived
    @notifications = get_notifications
    render :archived_notifications
  end

  private

  def get_notifications
    DeterLab.get_notifications(current_user_id)
  end

end
