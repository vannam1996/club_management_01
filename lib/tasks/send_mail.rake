desc "send_notification_report"
task send_notification_remind_report_month: :environment do
  club_ids = Club.ids
  clubs_has_report_ids = StatisticReport.search_club(club_ids)
    .search_time(Date.current.month, Date.current.year)
    .style(StatisticReport.styles[:monthly]).pluck(:club_id)
  clubs_not_report_ids = club_ids - clubs_has_report_ids
  SendEmailRemindJob.perform_now clubs_not_report_ids
  activities = []
  clubs_not_report_ids.each do |club_id|
    if club = Club.find_by(id: club_id)
      activities << Activity.new(key: Settings.remind_report_month, owner_id: 0,
        container: club, type_receive: Activity.type_receives[:club_manager],
        trackable_type: Settings.notification_report)
    end
  end
  Activity.import activities
end
