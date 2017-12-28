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
end
