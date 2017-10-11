class Admin::OrganizationsController < ApplicationController
  layout "admin_layout"
  before_action :admin_signed_in

  def index
    @organizations = Organization.newest
  end

  def show
    @organization = Organization.friendly.find params[:id]
    unless @organization
      flash[:danger] = t "not_found_oraganization"
      render :index
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new organization_params
    if @organization.save
      flash[:success] = t "create_organization_success"
      redirect_to admin_organizations_path
    else
      flash_error @organization
      redirect_to :back
    end
  end

  private
  def organization_params
    params.require(:organization).permit :name, :email, :phone, :logo,
      :location, :description
  end
end
