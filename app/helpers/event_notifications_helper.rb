module EventNotificationsHelper
  def category_event_activity
    [[t("notification"), Event.event_categories[:notification]],
    [t("activity_no_money"), Event.event_categories[:activity_no_money]],
    [t("activity_money"), Event.event_categories[:activity_money]]]
  end

  def url_form_new_and_edit action, club
    if action == Settings.action_edit
      club_event_notification_path(club)
    else
      club_event_notifications_path(club)
    end
  end
end
