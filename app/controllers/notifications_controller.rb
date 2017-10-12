class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user_club, only: :index
  def index
    @notifications = Activity.of_user_clubs(@user_club.map(&:club_id).uniq).oder_by_read
      .page(params[:page]).per Settings.notification_per_page
  end

  private
  def load_user_club
    @user_club = current_user.user_clubs.joined
    if @user_club.blank?
      flash[:danger] = t "no_notification"
      redirect_to notifications_path
    end
  end
end
