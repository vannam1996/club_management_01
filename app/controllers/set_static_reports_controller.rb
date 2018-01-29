class SetStaticReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :report_categories

  def index
    @statistic_report = StatisticReport.new
    @statistic_report.report_details.build
    respond_to do |format|
      format.js
    end
  end

  private
  def load_club
    @club = Club.find_by id: params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def report_categories
    @report_categories = @club.organization.report_categories.active
  end
end
