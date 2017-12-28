class SendEmailRemindJob < ApplicationJob
  queue_as :email

  def perform club_ids, style, time
    StatisticReportMailer.mail_remind_report(club_ids, style, time).deliver_later
  end
end
