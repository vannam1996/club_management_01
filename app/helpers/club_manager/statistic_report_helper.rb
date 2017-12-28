module ClubManager::StatisticReportHelper
  def option_select option
    option.map{|k, v| [t(k.to_s), v]}
  end
end
