class StatisticReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club, only: :create
  before_action :check_user, only: :create
  before_action :new_statistic, only: :create

  def create
    if @statistic_report.save
      flash[:success] = t "create_statistic_report_success"
    else
      flash[:danger] = t "create_statistic_report_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def statistic_report_params
    params.require(:statistic_report).permit :style, :club_id, :time,
      :item_report, :detail_report, :plan_next_month, :note, :others
  end

  def load_club
    @club = Club.find_by id: params[:statistic_report][:club_id]
    return if @club
    flash[:danger] = t "create_statistic_report_fail"
    redirect_to request.referer || root_url
  end

  def check_user
    return if can? :is_admin, @club
    flash[:warning] = t "manager_require"
    redirect_to request.referer || root_url
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
  end
end
