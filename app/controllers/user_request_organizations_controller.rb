class UserRequestOrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization, only: [:show, :edit]
  before_action :load_user_pendings, only: [:show, :edit]
  before_action :load_user_member, only: :update

  def show
    @members_pending = @user_pendings.includes(:user)
    respond_to do |format|
      format.js
    end
  end

  def edit
    if @user_pendings.update_all status: params[:status]
      flash[:success] = t "success_process"
    else
      flash[:danger] = t "error_in_process"
    end
    redirect_to organization_path @organization
  end

  def update
    @request = @member.update_attributes status: params[:status]
    flash[:errors] = t("error_process") unless @request
    respond_to do |format|
      format.js
    end
  end

  private
  def load_organization
    @organization = Organization.friendly.find_by slug: params[:id]
    return if @organization
    flash[:danger] = t("organization_not_found")
    redirect_to root_path
  end

  def load_user_pendings
    @user_pendings = @organization.user_organizations.pending
  end

  def load_user_member
    @member = UserOrganization.find_by id: params[:id]
    unless @member
      flash[:danger] = t "organization_not_found"
      redirect_to root_path
    end
  end
end
