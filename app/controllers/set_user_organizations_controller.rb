class SetUserOrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization, only: [:show, :edit, :update, :create]
  before_action :load_user_organization, only: :destroy
  before_action :load_user_admins, only: [:show, :edit]
  before_action :user_joined_organizations, only: [:show, :edit]

  def create
    ActiveRecord::Base.transaction do
      user_organization_create = []
      user_ids = params[:user_id]
      user_ids.each do |user_id|
        user_organization_create << UserOrganization.new(user_id: user_id, organization_id: @organization.id,
          is_admin: Settings.user_club.member, status: Settings.user_club.join)
      end
      UserOrganization.import user_organization_create
      flash[:success] = t "success_process"
      redirect_to organization_path @organization
    end
  rescue
    flash[:danger] = t "error_in_process"
    redirect_to organization_path @organization
  end

  def show
    @user_members = @user_organizations.are_member.includes(:user)
      .page(params[:page]).per Settings.page_member_not_manager
    respond_to do |format|
      format.js
    end
  end

  def edit
    @user_members = @user_organizations.are_member.includes(:user)
    respond_to do |format|
      format.js
    end
  end

  def update
    if params[:roles].present?
      service = UpdateUserOrganizationService.new params[:user_ids], params[:roles]
      UserOrganization.import service.update_user, on_duplicate_key_update: [:is_admin]
      flash[:success] = t "success_process"
      redirect_to organization_path @organization
    else
      flash[:danger] = t "cant_not_update"
      redirect_back fallback_location: organization_path
    end
  end

  def destroy
    unless @user_organization.destroy
      flash[:danger] = t("error_process")
    end
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

  def load_user_organization
    @user_organization = UserOrganization.find_by id: params[:id]
    return if @user_organization
    flash[:danger] = t("organization_not_found")
    redirect_back fallback_location: organization_path
  end

  def load_user_admins
    @user_admins = @organization.user_organizations.includes(:user).are_admin
  end

  def user_joined_organizations
    @user_organizations = @organization.user_organizations.joined
  end
end
