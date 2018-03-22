class UserDestroyService
  def initialize request
    request_body = request.body.read
    @data = JSON.parse(request_body)
  end

  def synchronized_wsm_user
    if is_deleted_action?
      user = User.find_by email: @data["user_group"]["user"]["email"]
      user.destroy if user
    end
  end

  private
  def is_deleted_action?
    @data["action"] == Settings.wsm_action_deleted && @data["user_group"] &&
      @data["user_group"]["user"]
  end
end
