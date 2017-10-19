class BaseDashboardController < ApplicationController
  layout "dashboard_layout"

  before_action :user_signed_in
  before_action :load_organizations
  before_action :load_verify

  protected

  def load_verify
    @admin = current_user.user_organizations.are_admin
    @managers = current_user.user_clubs.manager
    unless @admin.any? || @managers.any?
      flash[:danger] = t "not_authorities_to_access"
      redirect_to root_path
    end
  end

  def load_organizations
    @organizations = current_user.organizations
  end

  def correct_manager
    correct_manager = manager_of_club(current_user).find_by club_id: @club.id
    unless correct_manager
      flash[:danger] = t "not_correct_manager"
      redirect_to dashboard_path
    end
  end

  def load_correct_member
    correct_member = @member.user_clubs.find_by club_id: params[:club_id]
    unless correct_member
      flash[:danger] = t("user.cant_found")
      redirect_to dashboard_club_members_path params[:club_id]
    end
  end
end
