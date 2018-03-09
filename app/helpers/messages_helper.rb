module MessagesHelper
  def is_owner_message? message
    message.user_id == current_user.id
  end
end
