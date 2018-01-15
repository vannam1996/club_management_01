class WarningReportsController < ApplicationController

  def create
    club_ids = params[:club_id].split(" ")
    warning_report = []
    ActiveRecord::Base.transaction do
      club_ids.each do |club_id|
        warning_report << WarningReport.new(club_id: club_id, time: params[:report_type],
          year: params[:report_year], style: params[:report_style],
          deadline: params[:date_deadline])
      end
      WarningReport.import warning_report
      flash[:success] = t ".messenger_report_success"
    end
    respond_to do |format|
      format.js
    end
  end
end
