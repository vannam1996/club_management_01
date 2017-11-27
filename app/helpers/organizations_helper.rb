module OrganizationsHelper
  def select_case_view organization
    if !current_user.joined_organization?(organization) &&
      current_user.pending_organization?(organization)
      content_tag(:i, nil, class: "fa fa-check fa-2x", title: t("joined"))
    elsif current_user.joined_organization?(organization) &&
      !current_user.pending_organization?(organization)
      content_tag(:i, nil, class: "fa fa-exclamation-triangle", title: t("danger"))
    end
  end

  def view_organization?(organization, user)
    organization.status == Settings.professed || (UserOrganization.find_with_user_of_company(user.id, organization.id)).present?
  end

  def user_role
    [[t("members"), Settings.user_club.member],
    [t("manager"), Settings.user_club.manager]]
  end

  def selected_role user_organization
    user_organization.is_admin? ? Settings.user_club.manager : Settings.user_club.member
  end
end
