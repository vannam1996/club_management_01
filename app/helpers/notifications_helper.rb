module NotificationsHelper
  def notifications_result
    Activity.includes(:trackable, [owner: :user_clubs], :container)
      .of_user_clubs(current_user.user_clubs.joined.map(&:club_id)).oder_by_read
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
      club_album_path(club_id: notification.container_id, id: notification.trackable_id)
    end
  end

  def option_class read
    class_read = read.present? && read.include?(current_user.id) ? Settings.notifications.read : Settings.notifications.un_read
  end

  def size_notification notifications
    un_read = notifications.size
    notifications.each do |notification|
      if notification.user_read.present? && notification.user_read.include?(current_user.id)
        un_read = un_read - Settings.notifications.notification_read
      end
    end
    un_read
  end

  def check_user_club_joined? notification
    if @current_user_clubs.of_club(notification.container_id).present?
      @current_user_clubs.of_club(notification.container_id).joined?
    else
      @current_user_clubs.of_club(notification.trackable_id).joined?
    end
  end
end
