class StatisticReportMailer < ApplicationMailer
  def mail_to_club_manager_report_reject user, club, report
    @user = user
    @club = club
    @report = report
    @url = Settings.my_url
    mail to: @user.email, subject: t("reject_report_mail")
  end
end
