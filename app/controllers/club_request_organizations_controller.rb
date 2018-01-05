class ClubRequestOrganizationsController < ApplicationController
  before_action :load_request, only: [:update, :edit]
  before_action :load_organization, only: :show

  def show
    @requests = @organization.club_requests.pending.order_date_desc
    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @request.update_attributes status: params[:status].to_i
      flash[:success] = t("success_process")
    else
      flash[:danger] = t("error_process")
    end
    redirect_to organization_path @request.organization.slug
  end

  private
  def load_organization
    @organization = Organization.friendly.find_by slug: params[:id]
    return if @organization
    flash[:danger] = t("organization_not_found")
    redirect_to root_path
  end

  def load_request
    @request = ClubRequest.find_by id: params[:id]
    unless @request
      flash[:danger] = t "not_found_request"
      redirect_to root_path
    end
  end
end
