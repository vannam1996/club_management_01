class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def create
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)
    if @user.persisted?
      set_flash_message :notice, :success, kind: auth.provider if is_navigational_format?
      sign_in_and_redirect @user
    else
      flash[:notice] = t "auth_failure"
      redirect_to root_path
    end
  end

  alias framgia create
end
