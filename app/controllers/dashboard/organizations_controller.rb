class Dashboard::OrganizationsController < BaseDashboardController
  before_action :load_organization, only: [:show, :edit, :update]
  before_action :verify_manager_organization, only: [:show, :edit, :update]

  def show
    @members = @organization.user_organizations.includes(:user)
    @requests = @organization.club_requests.pending.order_date_desc
    @clubs = @organization.clubs.newest
  end

  def edit
  end

  def update
    if @organization.update_attributes organization_parmas
      flash[:success] = t("update_organization_success")
      redirect_to dashboard_organization_path(id: @organization.id)
    else
      flash[:danger] = t "error_update"
      render :edit
    end
  end

  private
  def load_organization
    @organization = Organization.friendly.find params[:id]
    unless @organization
      flash[:danger] = t("organization_not_found")
      redirect_to dashboard_path
    end
  end

  def organization_parmas
    status = params["organization"]["status"].to_i
    params.require(:organization).permit(:name, :description, :phone,
      :email, :location, :logo).merge! status: status
  end

  def verify_manager_organization
    @admin = (@organization.user_organizations.are_admin).find_by user_id: current_user
    unless @admin
      flash[:danger] = t "not_authorities_to_access"
      redirect_to dashboard_path
    end
  end
end
