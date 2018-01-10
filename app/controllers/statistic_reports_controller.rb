class StatisticReportsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :load_club, only: :create
  before_action :new_statistic, only: :create
  before_action :load_organization, except: %i(new destroy create)
  before_action :check_user_organization, only: :index
  before_action :load_statistic, only: %i(show update edit)

  def index
    if @organization
      club_ids = @organization.clubs.pluck :id
      @statistic_reports = Support::StatisticReportSupport
        .new club_ids, params[:page]
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
    club_ids = @organization.clubs.pluck :id
    @statistic_reports = Support::StatisticReportSupport.new club_ids, params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    if @statistic_report.save
      flash[:success] = t "create_statistic_report_success"
    else
      flash[:danger] = t "create_statistic_report_fail"
    end
    redirect_to request.referer || root_url
  end

  private
  def reject_report_params
    params.require(:statistic_report).permit(:reason_reject)
      .merge! status: params[:status].to_i
  end

  def statistic_report_params
    params.require(:statistic_report).permit(:club_id, :time,
      :item_report, :detail_report, :plan_next_month, :note, :others)
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
    return if @statistic_report
    flash.now[:danger] = t "not_found_statistic"
  end

  def approve_report
    if @statistic_report.approved!
      flash.now[:success] = t "approve_success"
    else
      flash.now[:danger] = t "approve_error"
    end
  end

  def reject_report
    if @statistic_report.update_attributes reject_report_params
      SendEmailJob.perform_now @statistic_report.user, @statistic_report.club,
        @statistic_report
      flash.now[:success] = t "reject_success"
    else
      flash.now[:danger] = t "reject_error"
    end
  end
end
