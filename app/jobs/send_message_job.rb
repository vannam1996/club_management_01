class SendMessageJob < ApplicationJob
  queue_as :chat

  def perform message, owner_id
    ActionCable.server.broadcast "club_#{message.club_id}_channel",
      message: render_message(message), message_owner: render_message_owner(message),
      owner_id: owner_id
  end

  def render_message message
    ApplicationController.renderer.render partial: "messages/message",
      locals: {message: message}
  end

  def render_message_owner message
    ApplicationController.renderer.render partial: "messages/message_owner",
      locals: {message: message}
  end
end
