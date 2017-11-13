class SetUserClubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_users, only: :update

  def update
    ActiveRecord::Base.transaction do
      user_club_update = []
      roles = params[:roles]
      @users.each.with_index(Settings.user_club.number) do |member, index|
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

  def load_users
    @users = @club.user_clubs.joined
  end
end
