class Dashboard::RequestClubsController < BaseDashboardController
  before_action :load_request, only: [:update, :show]

  def update
    ActiveRecord::Base.transaction do
      if @request.update_attributes status: params[:status].to_i
        if params[:status].to_i == ClubRequest.statuses[:joined]
          @club = Club.create_after_approve @request
          Club.create_user_club @club, @request
          send_mail_club_request @request.user_id, @club
        end
        flash[:success] = t("success_process")
        redirect_to dashboard_organization_path(id: @request.organization_id)
      else
        flash[:danger] = t("error_process")
        redirect_to :back
      end
    end
  rescue
    flash[:danger] = t("cant_not_update")
    redirect_to :back
  end

  private
  def load_request
    @request = ClubRequest.find_by id: params[:id]
    unless @request
      flash[:danger] = t "not_found_request"
      redirect_to dashboard_club_path
    end
  end

  def send_mail_club_request user_id, club
    @user = User.find_by id: user_id
    if @user.blank?
      flash[:danger] = t("user_not_found")
    else
      OrganizationMailer.mail_to_club_request(@user, club).deliver_later
    end
  end
end
