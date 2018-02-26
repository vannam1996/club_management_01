class StatisticReportsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_club, only: :create
  before_action :new_statistic, only: :create
  before_action :load_organization, except: %i(new destroy create)
  before_action :check_user_organization, only: :index
  before_action :load_statistic, only: %i(show update edit)

  def index
    if @organization
      @q = StatisticReport.search params[:q]
      club_ids = @organization.clubs.pluck :id
      @statistic_reports = Support::StatisticReportSupport
        .new club_ids, params[:page], params[:q]
      id_clubs_report = @statistic_reports.club_is_not_report.search(params[:q])
        .result.map(&:club_id)
      @clubs_not_report = Club.not_report(club_ids - id_clubs_report)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if params[:status].to_i == StatisticReport.statuses[:approved]
      approve_report
    elsif params[:status].to_i == StatisticReport.statuses[:rejected]
      reject_report
    end
    all_report
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    ActiveRecord::Base.transaction do
      if @statistic_report.save!
        create_detail_report @statistic_report
        flash.now[:success] = t "create_statistic_report_success"
        create_acivity @statistic_report, Settings.create_report,
          @club.organization, current_user, Activity.type_receives[:organization_manager]
        @reports = @club.statistic_reports.order_by_created_at
          .page(params[:page]).per Settings.per_page_report
      else
        flash.now[:danger] = t "create_statistic_report_fail"
      end
    end
  rescue
    flash.now[:danger] = t "create_statistic_report_fail"
  end

  private
  def reject_report_params
    params.require(:statistic_report).permit(:reason_reject)
      .merge! status: params[:status].to_i
  end

  def statistic_report_params
    params.require(:statistic_report).permit(:club_id, :time,
      :item_report, :detail_report, :plan_next_month, :note, :others,
      report_details_attributes: [:report_category_id, :detail, :style])
      .merge! style: params[:statistic_report][:style].to_i,
      year: params[:date][:year].to_i
  end

  def load_club
    @club = Club.find_by id: params[:statistic_report][:club_id]
    return if @club
    flash[:danger] = t "create_statistic_report_fail"
    redirect_to request.referer || root_url
  end

  def check_user_organization
    return if can? :manager, @organization
    flash[:warning] = t "manager_require"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_statistic
    @statistic_report = current_user.statistic_reports.new statistic_report_params
    case params[:statistic_report][:style]
    when Settings.style_statistic.month
      @statistic_report.time = params[:month]
    when Settings.style_statistic.quarter
      @statistic_report.time = params[:quarter]
    end
    @statistic_report.fund = @club.money
    @statistic_report.members = @club.member
    @statistic_report.status = :pending
  end

  def load_organization
    @organization = Organization.friendly.find_by slug: params[:organization_slug]
    return if @organization
    flash[:danger] = t "not_found_organization"
  end

  def load_statistic
    @statistic_report = StatisticReport.find_by id: params[:id]
    @report_details = @statistic_report.report_details.includes(:report_category)
      .group_by(&:report_category_id) if @statistic_report
    return if @statistic_report
    flash.now[:danger] = t "not_found_statistic"
  end

  def approve_report
    if @statistic_report.approved!
      flash.now[:success] = t "approve_success"
      create_acivity @statistic_report, Settings.approve_report,
        @statistic_report.club, current_user, Activity.type_receives[:club_manager]
    else
      flash.now[:danger] = t "approve_error"
    end
  end

  def reject_report
    if @statistic_report.update_attributes reject_report_params
      SendEmailJob.perform_now @statistic_report.user, @statistic_report.club,
        @statistic_report
      flash.now[:success] = t "reject_success"
      create_acivity @statistic_report, Settings.reject_report,
        @statistic_report.club, current_user, Activity.type_receives[:club_manager]
    else
      flash.now[:danger] = t "reject_error"
    end
  end

  def all_report
    @q = StatisticReport.search params[:q]
    club_ids = @organization.clubs.pluck :id
    @statistic_reports = Support::StatisticReportSupport
      .new club_ids, params[:page], params[:q]
    id_clubs_report = @statistic_reports.club_is_not_report.search(params[:q])
      .result.map(&:club_id)
    @clubs_not_report = Club.not_report(club_ids - id_clubs_report)
  end

  def create_detail_report static_report
    @report_categorys = ReportCategory.load_category.active.by_category(@club.organization_id)
    if @report_categorys
      service = CreateReportService.new @report_categorys, static_report, @club
      ReportDetail.import service.create_report
    end
  end
end
