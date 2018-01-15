class SendEmailRemindJob < ApplicationJob
  queue_as :email

  def perform club_ids
    StatisticReportMailer.mail_remind_report(club_ids).deliver_later
  end
end
