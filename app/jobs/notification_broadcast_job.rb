class NotificationBroadcastJob < ApplicationJob
  queue_as :notify

  def perform notification, lists_received
    ActionCable.server.broadcast("notification_channel",
      notification: render_notify(notification), lists_received: lists_received)
  end

  private
  def render_notify notification
    ApplicationController.renderer.render(partial: "notifications/notification_update",
      locals: {notification: notification})
  end
end
