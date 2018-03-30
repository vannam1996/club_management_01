class Admin::ClubsController < Admin::AdminController
  before_action :load_organization
  before_action :load_club, only: [:show, :destroy]

  def index
    @q = @organization.clubs.search params[:q]
    @clubs = @q.result.includes(:user_clubs)
     .newest.page(params[:page]).per Settings.club_per_page
  end

  def show
  end

  def destroy
    if @club.destroy
      flash.now[:success] = t "delete_success"
    else
      flash.now[:danger] = t "delete_club_type_error"
    end
  end

  private
  def load_organization
    @organization = Organization.friendly.find_by slug: params[:organization_id]
    return if @organization
    flash[:danger] = t("organization_not_found")
    redirect_to admin_path
  end

  def load_club
    @club = Club.friendly.find_by slug: params[:id]
    return if @club
    flash[:danger] = t("not_found")
    redirect_to admin_path
  end
end
