module StatisticReportsHelper
  def option_select option
    option.map{|k, v| [t(k.to_s), v]}
  end

  def month_report data
    t "#{StatisticReport.months.key data}"
  end

  def quarter_report data
    t "#{StatisticReport.quarters.key data}"
  end

  def link_approve_report organization_slug, statistic_report
    link_to statistic_report_path(statistic_report, organization_slug: @organization.slug,
      status: StatisticReport.statuses[:approved]), remote: :true, method: :patch,
      title: t("accept"), data: {confirm: t("confirm_approve")},
      class: "btn btn-sm btn-breez aprove-user" do
      content_tag(:i, "", class: "fa fa-check-square-o")
    end
  end

  def link_reject_report organization_slug, statistic_report
    link_to edit_statistic_report_path(statistic_report, organization_slug: @organization.slug),
      title: t("reject"), remote: true,
      class: "btn btn-sm btn-danger aprove-user" do
      content_tag(:i, "", class: "fa fa-ban")
    end
  end
end
