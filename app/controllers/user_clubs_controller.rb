class UserClubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club, only: [:update, :show, :destroy]
  before_action :load_user_club, only: :destroy
  before_action :check_user_is_manager, only: :destroy

  def create
    user_club = UserClub.new request_params
    if user_club.save
      flash[:success] = t("success_for_join")
    else
      flash[:danger] = t("error_for_join")
    end
    @club = user_club.club
    flash[:success] = t("join_and_wait")
    redirect_to club_path @club
  end

  def show
    @user_clubs = @club.user_clubs.joined.includes(:user)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @club = @user_club.club
    if @user_club.destroy
      flash[:success] = t("cancel_success")
    else
      flash_error @user_club
    end
    @user_club = UserClub.new
    flash[:success] = t("see_you_next_time")
    redirect_back fallback_location: club_path
  end

  private
  def request_params
    params.require(:user_club).permit(:club_id).merge! user_id: current_user.id
  end

  def load_user_club
    @user_club = current_user.user_clubs.find_by club_id: params[:club_id]
    unless @user_club
      flash[:danger] = t("not_found_user_club")
      redirect_back fallback_location: club_path
    end
  end

  def check_user_is_manager
    if @user_club.is_manager && @club.user_clubs.manager.size == Settings.user_club.manager
      flash[:danger] = t("user_club_not_remove")
      redirect_to organization_club_path @club.organization.slug, @club
    end
  end

  def load_club
    @club = Club.friendly.find params[:id]
    return if @club
    flash[:danger] = t("not_found_club")
    redirect_back fallback_location: root_path
  end
end
