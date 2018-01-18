module ClubManager::StatisticReportHelper
  def option_select option
    option.map{|k, v| [t(k.to_s), v]}
  end

  def set_title_edit_report report
    if report.monthly?
      t "title_edit_report", time: month_report(report.time), year: report.year
    elsif report.quarterly?
      t "title_edit_report", time: quarter_report(report.time), year: report.year
    end
  end
end
