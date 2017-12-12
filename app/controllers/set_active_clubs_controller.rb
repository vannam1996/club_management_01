class SetActiveClubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :check_is_admin, only: :edit

  def edit
    if @club.update_attributes is_active: params[:active]
      flash[:success] = t "activated_success"
    else
      flash[:danger] = t("error_update")
    end
    redirect_to organization_club_path @club.organization.slug, @club
  end

  private
  def load_club
    @club = Club.find_by slug: params[:id]
    return if @club
    flash[:danger] = t("not_found")
    redirect_to root_path
  end

  def check_is_admin
    unless can? :is_admin, @club
      redirect_to root_path
    end
  end
end
