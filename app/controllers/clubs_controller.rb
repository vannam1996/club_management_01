class ClubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club, only: [:show, :verify_club]
  before_action :verify_club, only: :show

  def index
    organizations_joined = Organization.by_user_organizations(
      current_user.user_organizations.joined
    )
    @club_joined = Club.of_organizations(
      organizations_joined
    ).of_user_clubs(current_user.user_clubs.joined)
    clubs = Club.of_organizations(organizations_joined).without_clubs(
      @club_joined
    )
    @q = clubs.search(params[:q])
    @clubs = @q.result.newest.page(params[:page]).per Settings.club_per_page
    @user_organizations = current_user.user_organizations.joined
    @organizations = Organization.by_user_organizations(
      current_user.user_organizations.joined
    )
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    list_events = @club.events
    @q = list_events.search(params[:q])
    @events = @q.result.newest.includes(:budgets).page(params[:page]).per Settings.per_page
    @time_line_events = @events.by_current_year.group_by_quarter
    @message = Message.new
    @user_club = UserClub.new
    @support = Support::ClubSupport.new(@club, params[:page], nil)
    @albums = @club.albums.newest.includes(:images)
    respond_to do |format|
      format.html
      format.js
    end
  end

  protected
  def verify_club
    return if @club.is_active?
    flash[:danger] = t("club_is_lock")
    redirect_to clubs_url
  end

  def load_club
    @club = Club.friendly.find params[:id]
    return if @club
    flash[:danger] = t("not_found")
    redirect_to clubs_url
  end
end
