class NotificationsController < ApplicationController

  before_filter :require_login

  # all notifications list
  def index
    @notifications = get_notifications
    setup_gon
    render :all_notifications
  end

  # new notifications list
  def new_only
    @notifications = get_notifications.reject(&:read?)
    setup_gon
    render :new_notifications
  end

  # marking the notification as read
  def mark_as_read
    DeterLab.mark_notifications(current_user_id, [ params[:id] ], [ { isSet: true, tag: Notification::READ } ])
    render text: 'ok'
  end

  private

  def get_notifications
    DeterLab.get_notifications(current_user_id)
  end

  def setup_gon
    gon.old_threshold_days = 14
    gon.notifications = @notifications.map { |n| n.to_json(deter_lab) }
    gon.mark_as_read_path = mark_as_read_notification_path(':id')
    gon.new_project_type = Notification::TYPE_NEW_PROJECT
  end

end
