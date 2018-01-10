class SendEmailJob < ApplicationJob
  queue_as :email

  def perform user, club, report
    @user = user
    @club = club
    @report = report
    StatisticReportMailer.mail_to_club_manager_report_reject(@user,
      @club, @report).deliver_later
  end
end
