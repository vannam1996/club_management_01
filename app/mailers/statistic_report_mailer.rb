class StatisticReportMailer < ApplicationMailer
  def mail_to_club_manager_report_reject user, club, report
    @user = user
    @club = club
    @report = report
    @url = Settings.my_url
    mail to: @user.email, subject: t("reject_report_mail")
  end

  def mail_remind_report club_ids
    user_ids = UserClub.by_club_ids(club_ids).manager.pluck(:user_id).uniq
    @users = User.done_by_ids user_ids
    @url = Settings.my_url
    @clubs = Club.not_report club_ids
    mail to: @users.map(&:email).uniq, subject: t("remind_report_mail")
  end
end
