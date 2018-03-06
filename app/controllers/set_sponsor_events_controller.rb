class SetSponsorEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization, only: :index
  before_action :load_sponsor, only: :show

  def index
    @sponsors = @organization.sponsors.newest.page(params[:page])
      .per Settings.per_page_report_category
  end

  def show; end

  private
  def load_organization
    @organization = Organization.find_by id: params[:organization_id]
    return if @organization
    flash[:danger] = t("organization_not_found")
    redirect_to root_url
  end

  def load_sponsor
    @sponsor = Sponsor.find_by id: params[:id]
    unless @sponsor
      flash[:danger] = t "not_found"
      redirect_to club_event_path @club, @event
    end
  end
end
