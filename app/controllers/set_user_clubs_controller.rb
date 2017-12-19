class SetUserClubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club

  def create
    ActiveRecord::Base.transaction do
      user_club_create = []
      user_ids = params[:user_id]
      user_ids.each do |user_id|
        user_club_create << UserClub.new(user_id: user_id, club_id: params[:id],
          is_manager: Settings.user_club.member, status: Settings.user_club.join)
      end
      UserClub.import user_club_create
      flash[:success] = t "success_process"
      redirect_to club_path @club
    end
  rescue
    flash[:danger] = t "error_in_process"
    redirect_to club_path @club
  end

  def update
    ActiveRecord::Base.transaction do
      user_club_update = []
      roles = params[:roles]
      user_ids = params[:user_id]
      user_ids.each.with_index(Settings.user_club.number) do |user_id, index|
        member = UserClub.load_user(user_id)
        if member.is_manager != roles[index]
          member.is_manager = roles[index]
          user_club_update << member
        end
      end
      UserClub.import user_club_update, on_duplicate_key_update: [:is_manager]
      flash[:success] = t "success_process"
      redirect_to club_path @club
    end
  rescue
    flash[:danger] = t "cant_not_update"
    redirect_back fallback_location: club_path
  end

  private
  def load_club
    @club = Club.friendly.find params[:id]
  rescue
    flash[:danger] = t "not_found_club"
    redirect_back fallback_location: club_path
  end
end
