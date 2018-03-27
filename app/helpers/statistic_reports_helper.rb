module StatisticReportsHelper
  def option_select option
    option.map{|k, v| [t(k.to_s), v]}
  end

  def month_report data
    t StatisticReport.months.key(data).to_s
  end

  def quarter_report data
    t StatisticReport.quarters.key(data).to_s
  end

  def link_approve_report organization_slug, statistic_report
    link_to statistic_report_path(statistic_report, organization_slug: organization_slug,
      status: StatisticReport.statuses[:approved], q: params_reports,
      style_report: StatisticReport.styles[:monthly]), remote: :true, method: :patch,
      title: t("accept"), data: {confirm: t("confirm_approve")},
      class: "btn btn-sm btn-breez aprove-user" do
      content_tag(:i, "", class: "fa fa-check-square-o")
    end
  end

  def link_reject_report organization_slug, statistic_report
    link_to edit_statistic_report_path(statistic_report, organization_slug: organization_slug),
      title: t("reject"), remote: true,
      class: "btn btn-sm btn-danger aprove-user" do
      content_tag(:i, "", class: "fa fa-ban")
    end
  end

  def url_reject_report organization_slug, statistic_report
    statistic_report_path(statistic_report,
      organization_slug: organization_slug,
      status: StatisticReport.statuses[:rejected], q: params_reports,
      style_report: StatisticReport.styles[:monthly])
  end

  def load_event club, category
    club.events.by_event(category).by_months(Date.current.month).by_current_year
  end

  def money_expense event
    if event.get_money_member?
      event.expense * event.budgets.size
    else
      event.expense
    end
  end

  def is_can_edit_report? report
    current_user.id == report.user_id && (report.pending? || report.rejected?)
  end
end
