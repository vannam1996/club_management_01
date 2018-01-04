module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map{|msg| content_tag(:li, msg)}.join
    content_tag(:div, messages, content_tag(:button, "×", type: "button", onclick: "close_alert()",
      class: "close", "data-dismiss": "alert"),
      class: "alert alert-error alert-danger", id: "alert")
  end
end
