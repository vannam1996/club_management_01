class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user_club, only: [:index, :update]
  def index
    @notifications = Activity.of_user_clubs(@user_club.map(&:club_id).uniq).oder_by_read
      .page(params[:page]).per Settings.notification_per_page
      respond_to do |format|
       format.html
       format.js
      end
  end

  def update
    @notifications = Activity.of_user_clubs @user_club.map(&:club_id).uniq
    @notifications.each do |notification|
      arr_read_all = notification.user_read
      if arr_read_all.blank?
        arr_read_all = [current_user.id]
        notification.update_attributes user_read: arr_read_all
      elsif !arr_read_all.include?(current_user.id)
        arr_read_all = arr_read_all.push(current_user.id)
        notification.update_attributes user_read: arr_read_all
      end
    end
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
