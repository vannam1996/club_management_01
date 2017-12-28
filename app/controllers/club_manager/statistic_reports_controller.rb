class ClubManager::StatisticReportsController < BaseClubManagerController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_report, only: :show

  def index
    if @club
      reports = @club.statistic_reports
      @q = reports.search params[:q]
      if params[:q]
        @reports = @q.result.page(params[:page]).per Settings.per_page_report
      else
        @reports = @club.statistic_reports.monthly.page(params[:page])
          .per Settings.per_page_report
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  private

  def load_report
    @report = @club.statistic_reports.find_by id: params[:id] if @club
    return if @report
    flash.now[:danger] = t "error_find_report"
  end

  def load_club
    @club = Club.friendly.find_by slug: params[:club_id]
    return if @club
    flash.now[:danger] = t "error_load_club"
  end
end
