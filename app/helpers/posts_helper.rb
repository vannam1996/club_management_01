module PostsHelper
  def status_remote_by_params_action action
    action != Settings.edit
  end

  def text_button action
    action == Settings.edit ? t("posts.post_update") : t("posts.post_now")
  end
end
