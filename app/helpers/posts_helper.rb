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

  def gsub_url_youtube url
    url.gsub("watch?v=", "embed/")
  end

  def take_image post, size
    post.post_galleries.image.take(size)
  end

  def list_image post
    post.post_galleries.image
  end

  def list_video post
    post.post_galleries.video
  end

  def rest_gallery_size post
    if list_image(post).size > Settings.image_view_post_concat
      list_image(post).size + list_video(post).size -
        Settings.image_view_post_concat - Settings.video_view_post_concat
    else
      list_video(post).size - Settings.video_view_post_concat
    end
  end

  def last_index post, index
    index == take_image(post, Settings.image_view_post_concat).size - Settings.one
  end

  def is_have_rest_gallery? post
    list_image(post).size > Settings.image_view_post_concat ||
      list_video(post).size > Settings.video_view_post_concat
  end
end
