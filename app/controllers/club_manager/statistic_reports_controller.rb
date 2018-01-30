class ClubManager::StatisticReportsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_club
  before_action :load_report, only: %i(show edit update)
  before_action :load_report_categories, only: %i(index edit new)

  def index
    gon_variable
    if @club
      @statistic_report = current_user.statistic_reports.build club_id: @club.id
      @statistic_report.report_details.build
      all_report
    end
    respond_to do |format|
      format.js
    end
  end

  def show; end

  def edit
    gon_variable
  end

  def update
    send_notification
    if @report && @report.update_attributes(params_with_check_style)
      flash.now[:success] = t "update_report_success"
    elsif @report
      flash.now[:danger] = t "update_report_error"
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    @statistic_report = current_user.statistic_reports.build club_id: @club.id
    @statistic_report.report_details.build
    all_report
    respond_to do |format|
      format.js
    end
  end

  private
  def report_params
    params.require(:statistic_report).permit(:item_report, :detail_report,
      :plan_next_month, :note, :year, :others, report_details_attributes:
      [:report_category_id, :detail, :id, :_destroy])
      .merge!(style: params[:statistic_report][:style].to_i,
      status: :pending, reason_reject: nil)
  end

  def params_with_check_style
    params_with_check_style = report_params
    case params_with_check_style[:style]
    when Settings.style_month
      params_with_check_style.merge! time: params[:month].to_i
    when Settings.style_quater
      params_with_check_style.merge! time: params[:quarter].to_i
    end
  end

  def load_report
    @report = @club.statistic_reports.find_by id: params[:id] if @club
    @report_details = @report.report_details.includes(:report_category)
      .group_by(&:report_category_id) if @report
    return if @report
    flash.now[:danger] = t "error_find_report"
  end

  def all_report
    reports = @club.statistic_reports
    @q = reports.search params[:q]
    if params[:q]
      @params_q = params[:q]
      @reports = @q.result.order_by_created_at.page(params[:page]).per Settings.per_page_report
    else
      @reports = reports.order_by_created_at.page(params[:page])
        .per Settings.per_page_report
    end
  end

  def load_club
    @club = Club.friendly.find_by slug: params[:club_id]
    return if @club
    flash.now[:danger] = t "error_load_club"
  end

  def gon_variable
    gon.month = StatisticReport.styles[:monthly]
    gon.quarter = StatisticReport.styles[:quarterly]
  end

  def send_notification
    if @report && @report.rejected?
      create_acivity @report, Settings.update_report,
        @club.organization, current_user, Activity.type_receives[:organization_manager]
    end
  end

  def load_report_categories
    @report_categories = @club.organization.report_categories.active
  end
end
