module ReportCategoriesHelper
  def set_icon status
    if status
      content_tag(:i, "", class: "fa fa-check")
    else
      content_tag(:i, "", class: "fa fa-times")
    end
  end

  def check_style_event id, ids
    ids.include? id
  end

  def list_style_category report_category
    list_style = ""
    if report_category && report_category.style_event.present?
      report_category.style_event.each do |event_id|
        if report_category.style_event.last == event_id
          list_style += t ".#{Event.event_categories.key(event_id)}"
        else
          list_style += t(".#{Event.event_categories.key(event_id)}") + ", "
        end
      end
      list_style
    else
      t ".no_style"
    end
  end
end
