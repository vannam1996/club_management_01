module PostsHelper
  def status_remote_by_params_action action
    action != Settings.edit
  end

  def text_button action
    action == Settings.edit ? t("posts.post_update") : t("posts.post_now")
  end

  def url_image f
    if f.object.url.present?
      f.object.url
    else
      Settings.image_plus
    end
  end

  def title_form action
    action == Settings.edit ? t("posts.title_modal_edit_post") : t("posts.title_modal_new_post")
  end
end
