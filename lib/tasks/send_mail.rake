desc "send_notification_report"
task send_notification_remind_report_month: :environment do
  club_ids = Club.ids
  clubs_has_report_ids = StatisticReport.search_club(club_ids)
    .search_time(Date.current.month, Date.current.year)
    .monthly.pluck(:club_id)
  clubs_not_report_ids = club_ids - clubs_has_report_ids
  SendEmailRemindJob.perform_now(clubs_not_report_ids, StatisticReport.styles[:monthly],
    Date.current.month)
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

task send_notification_remind_report_quarter: :environment do
  month = Date.current.month
  quarter_current = (month - Settings.one) / Settings.month_per_quarter + Settings.one
  club_ids = Club.ids
  clubs_has_report_ids = StatisticReport.search_club(club_ids)
    .search_time(quarter_current, Date.current.year)
    .quarterly.pluck(:club_id)
  clubs_not_report_ids = club_ids - clubs_has_report_ids
  SendEmailRemindJob.perform_now(clubs_not_report_ids, StatisticReport.styles[:quarterly],
    quarter_current)
  activities = []
  clubs_not_report_ids.each do |club_id|
    if club = Club.find_by(id: club_id)
      activities << Activity.new(key: Settings.remind_report_quarter, owner_id: 0,
        container: club, type_receive: Activity.type_receives[:club_manager],
        trackable_type: Settings.notification_report)
    end
  end
  Activity.import activities
end
