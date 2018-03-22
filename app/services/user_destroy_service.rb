class UserDestroyService
  def initialize request
    request_body = request.body.read
    @data = JSON.parse(request_body)
  end

  def synchronized_wsm_user
    if @data["user"].present? && @data["user"]["deleted_at"].present?
      user = User.find_by email: @data["user"]["email"]
      user.destroy if user
    end
  end
end
