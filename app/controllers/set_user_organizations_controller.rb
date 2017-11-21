class SetUserOrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization, only: :create

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

  private
  def load_organization
    @organization = Organization.friendly.find_by slug: params[:id]
    return if @organization
    flash[:danger] = t("organization_not_found")
    redirect_to root_path
  end
end
