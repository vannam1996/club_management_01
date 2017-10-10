module NotificationsHelper
  def notifications_result
    Activity.of_user_clubs(current_user.user_clubs.joined.map(&:club_id)).oder_by_read
  end

  def option_image notification
    img =  notification.owner.avatar
    case notification.trackable_type
    when Club.name
      img =  notification.trackable.logo
    when Event.name
      img =  notification.trackable.image
    when Organization.name
      img =  notification.trackable.logo
    when Image.name
      img =  notification.trackable.url
    end
    image_tag img, class: "img-responsive"
  end

  def url_notification notification
    case notification.trackable_type
    when Settings.notification_event
      club_event_path(id: notification.trackable_id, club_id: notification.container_id)
    when Settings.notification_club
      club_path(id: notification.trackable_id)
    else
      club_albums_path(club_id: notification.container_id)
    end
  end
end
