class ClubManager::UserClubsController < BaseClubManagerController
  before_action :load_userclub, only: [:update, :destroy]
  before_action :load_club

  def index
    @club = Club.find_by id: params[:club_id]
    unless @club
      flash[:danger] = t "cant_found_club"
      redirect_to club_manager_path
    end
    @user_clubs = @club.user_clubs.unactive
  end

  def update
    if @user_club.joined!
      flash[:success] = t "club_manager.user_club.success_update"
    else
      flash_error @club
    end
    redirect_back fallback_location: club_manager_path(@club)
  end

  def create
    ActiveRecord::Base.transaction do
      params[:users].each do |user_id|
        UserClub.create user_id: user_id, club_id: @club.id, status: :joined
      end
      flash[:success] = t("add_user_successfully")
      redirect_back fallback_location: club_manager_path(@club)
    end
  rescue
    flash[:danger] = t("error_in_processing")
    redirect_to :back
  end

  def destroy
    if @user_club.destroy
      flash.now[:success] = t("deleted_successfull")
    else
      flash.now[:danger] = t("error_process")
    end
    redirect_back(fallback_location: club_manager_path(@club)) unless request.xhr?
  end

  private
  def load_userclub
    @user_club = UserClub.find_by id: params[:id]
    unless @user_club
      flash[:danger] = t "cant_found_request"
      redirect_to(club_manager_path) unless request.xhr?
    end
  end
end
