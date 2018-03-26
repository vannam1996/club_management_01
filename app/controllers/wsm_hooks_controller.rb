class WsmHooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_token!
  before_action :verify_domain!

  def update
    user_destroy_service = UserDestroyService.new request
    user_destroy_service.synchronized_wsm_user

    head :ok
  end

  private
  def verify_token!
    @token = params[:access_token]
    if @token.blank? || @token != Settings.access_token
      render nothing: true
      return
    end
  end

  def verify_domain!
    unless request.domain == Settings.wsm_domain
      render nothing: true
      return
    end
  end
end
