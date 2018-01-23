module ReportCategoriesHelper
  def set_icon status
    if status
      content_tag(:i, "", class: "fa fa-check")
    else
      content_tag(:i, "", class: "fa fa-times")
    end
  end
end
