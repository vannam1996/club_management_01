class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization, only: [:show, :edit]

  def index
    @q = Organization.search(params[:q])
    @organizations = @q.result.newest.includes(:users).page(params[:page])
      .per Settings.club_per_page
  end

  def show
    @user_organization = current_user.user_organizations
      .find_by organization_id: @organization.id
    @q = @organization.clubs.search(params[:q])
    @clubs = @q.result.page(params[:page]).per Settings.club_per_page
    @add_user_club = User.without_user_ids(@organization.user_organizations.map(&:user_id))
    @organization_event = @organization.events.status_public(true)
      .newest.page(params[:page]).per Settings.club_per_page
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  private
  def load_organization
    @organization = Organization.includes(:events).friendly.find_by slug: params[:id]
    return if @organization
    flash[:danger] = t("organization_not_found")
    redirect_to root_url
  end
end
