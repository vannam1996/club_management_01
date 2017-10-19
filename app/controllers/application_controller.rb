class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  include ApplicationHelper

  def user_signed_in
    unless user_signed_in?
      flash[:danger] = t("user.require_login")
      redirect_to root_path
    end
  end

  def current_user? user
    current_user == user
  end

  def correct_user
    @user = User.find_by id: params[:id]
    unless current_user?(@user)
      flash[:danger] = t("user.edit_require")
      redirect_to root_url
    end
  end

  def load_organization
    @organization = Organization.friendly.find params[:id]
    unless @organization
      flash[:danger] = t("cant_found")
      redirect_to root_url
    end
  end

  def admin_signed_in
    unless admin_signed_in?
      flash[:danger] = t("admin_require")
      redirect_to new_admin_sessions_path
    end
  end

  def create_acivity trackable, key, container, owner
    Activity.create! key: key, container: container,
    trackable: trackable, owner: owner
  end

  def load_club
    @club = Club.friendly.find params[:club_id]
    return if @club
    flash[:danger] = t("not_found_club")
    redirect_to :back
  end

  private
  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def after_sign_out_path_for _resource
    request.referrer || my_clubs_path
  end
end
