module EventNotificationsHelper
  def category_event_activity
    [[t("notification"), Event.event_categories[:notification]],
    [t("activity_money"), Event.event_categories[:activity_money]]]
  end

  def url_form_new_and_edit action, club
    if action == Settings.action_edit
      club_event_notification_path(club)
    else
      club_event_notifications_path(club)
    end
  end

  def group_by_month events
    events.group_by{|e| e.date_start&.beginning_of_month}
  end

  def confirm_delete event_category
    if event_category == Event.event_categories[:notification]
      t(".confirm_notification")
    else
      t(".confirm_activity")
    end
  end
end
