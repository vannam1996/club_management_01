module Dashboard::LayoutHelper

  def organization_manager_verify?
    current_user.user_organizations.are_admin.any?
  end

  def club_manager_verify?
    current_user.user_clubs.manager.any?
  end

  def set_tag_a class_icon, text
    concat(content_tag(:a, class: ["sidebar-nav-menu", "menu_dropdown"], href: t("do_nothing")) do
      concat(content_tag(:i, nil,
        class: ["fa", "fa-angle-left", "sidebar-nav-indicator", "sidebar-nav-mini-hide"]))
      concat(content_tag(:i, nil, class: class_icon))
      concat(content_tag(:span, text, class: "sidebar-nav-mini-hide"))
    end)
  end

  def load_menu_club_manager user_clubs
    if club_manager_verify?
      content_tag(:li) do
        set_tag_a ["gi gi-user", "sidebar-nav-icon"], t("my_clubs")
        load_list_item user_clubs, "club"
      end
    end
  end

  def load_menu_organization_manager organizations
    if organization_manager_verify?
      content_tag(:li) do
        set_tag_a ["gi gi-group", "sidebar-nav-icon"], t("my_organization")
        load_list_item organizations, "organization"
      end
    end
  end

  def load_list_item items, name_manager
    concat(content_tag(:ul, class: "menu_load") do
      items.each do |item|
        set_link_item item, name_manager
      end
    end)
  end

  def set_link_item item, name_manager
    concat(content_tag(:li, nil) do
      if(name_manager == "club")
        link_to item.name, dashboard_club_path(item.club_id)
      else
        link_to item.name, dashboard_organization_path(id: item.id)
      end
    end)
  end

  def view_class_dashboard event
    event.pay_money? ? "text-danger" : "text-success"
  end

  def time_join time
    timejoin = time.split("*")
  end
end
