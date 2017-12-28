class ClubsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource find_by: :slug
  before_action :verify_club, only: :show
  before_action :load_user_organizations, only: :show
  before_action :load_organization, only: [:update]

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
    @club_types = ClubType.includes(:organization)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @statistic_report = current_user.statistic_reports.build club_id: @club.id
    @album = Album.new
    list_events = @club.events
    @q = list_events.search(params[:q])
    @events = @q.result.newest.includes(:budgets).page(params[:page]).per Settings.per_page
    @time_line_events = @events.by_current_year.group_by_quarter
    @message = Message.new
    @user_club = UserClub.new
    @infor_club = Support::ClubSupport.new(@club, params[:page], nil)
    @albums = @club.albums.newest.includes(:images)
    @add_user_club = @user_organizations.user_not_joined(@club.user_clubs.map(&:user_id))
    @members_not_manager = @infor_club.members_not_manager.page(params[:page])
      .per Settings.page_member_not_manager
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if club_params
      @organizations = current_user.user_organizations.joined
      if @club.update_attributes club_params
        create_acivity @club, Settings.update, @club, current_user
        flash[:success] = t "club_manager.club.success_update"
      else
        flash_error @club
      end
      redirect_to organization_club_path @organization, @club
    else
      flash[:danger] = t "params_image_blank"
      redirect_to organization_club_path @organization, @club
    end
  end

  protected
  def verify_club
    if !@club.is_active? && !@club.is_admin?(current_user)
      flash[:danger] = t "club_not_active"
      redirect_to root_path
    end
  end

  # def load_club
  #   @club = Club.find_by slug: params[:id]
  #   return if @club
  #   flash[:danger] = t("not_found")
  #   redirect_to root_path
  # end

  def load_user_organizations
    @user_organizations = @club.organization.user_organizations.joined.includes :user
    return if @user_organizations
    flash[:danger] = t "not_found"
    redirect_to clubs_url
  end

  def load_organization
    @organization = Organization.find_by id: @club.organization_id
    unless @organization
      flash[:danger] = t "not_found_organization"
      redirect_to request.referer
    end
  end

  def club_params
    if params[:club].present?
      params.require(:club).permit :logo, :image
    end
  end
end
