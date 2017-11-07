module ClubsHelper
  def get_day_view days
    days.join("-")
  end

  def get_field_club field
    raw(field) if field.present?
  end

  def check_date days, day
    days.include? day
  end

  def view_detail_club content_view
    if content_view.blank?
      html = <<-HTML
        <h5 class="text-center"><strong><i>#{t("content_empty")}</i></strong></h5>
      HTML
      raw html
    else
      html = <<-HTML
        #{content_view}
      HTML
      raw html
    end
  end

  def check_view_manager club
    if current_user.user_clubs.manager.find_by(club_id: club.id).present?
      link_to t("view_more"), dashboard_club_path(club.id), class: "btn btn-success"
    else
      link_to t("view_more"), "javascript:void(0)", title: t("club_is_lock"), class: "btn btn-default"
    end
  end

  def albums_club album
    img = album.images.first.url
  end
end
