class UserDestroyService
  def initialize request
    request_body = request.body.read
    @data = JSON.parse(request_body)
  end

  def synchronized_wsm_user
    if is_deleted_action?
      user = User.find_by email: @data["user"]["email"]
      user.destroy if user
    elsif is_updated_action?
      user = User.find_by email: @data["user"]["email"]
      if user && @data["user"]["name"]
        user.update_attributes full_name: @data["user"]["name"]
      end
    end
  end

  private
  def is_deleted_action?
    @data["action"] == Settings.wsm_action_deleted && @data["user"].present?
  end

  def is_updated_action?
    @data["action"] == Settings.wsm_action_updated && @data["user"].present?
  end
end
