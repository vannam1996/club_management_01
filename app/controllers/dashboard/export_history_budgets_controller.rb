class Dashboard::ExportHistoryBudgetsController < BaseDashboardController
  before_action :load_club, only: :index
  def index
    @event_clubs = @club.events.without_notification(Settings.notification).newest
    @events = @event_clubs.by_created_at params[:first_date], params[:second_date]
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers["Content-Disposition"] = "filename='#{t("history_budget")}: #{@club.name}.xlsx'"
      }
    end
  end

  def create
  end

  private
  def load_club
    @club = Club.find_by slug: params[:id]
    unless @club
      flash[:danger] = t "club_manager.cant_fount"
      redirect_to dashboard_path
    end
  end
end
