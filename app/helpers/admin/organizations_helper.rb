module Admin::OrganizationsHelper
  def title_form_org action
    action == Settings.edit ? @organization.name : t("admin_manage.org.new")
  end

  def title_button_org action
    action == Settings.edit ? t("admin_manage.org.update") : t("admin_manage.org.new")
  end

  def is_action_new_or_create_organization? action
    params[:action] == Settings.action_new || params[:action] == Settings.action_create
  end
end
