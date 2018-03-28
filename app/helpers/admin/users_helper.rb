module Admin::UsersHelper
  def title_form_user action
    action == Settings.edit ? @user.full_name : t("admin_manage.new_user")
  end

  def title_button_form action
    action == Settings.edit ? t("admin_manage.update_user") : t("admin_manage.new_user")
  end

  def user_clubs_of_user user
    user.user_clubs.includes(:club) if user
  end

  def user_oranizations_of_user user
    user.user_organizations.includes(:organization) if user
  end
end
