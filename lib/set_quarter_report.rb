class SetQuarterReport
  def initialize params
    @params = params
  end

  def quarter_report
    case @params.to_i
    when StatisticReport.quarters[:quarter_1]
      Settings.quarter_1
    when StatisticReport.quarters[:quarter_2]
      Settings.quarter_2
    when StatisticReport.quarters[:quarter_3]
      Settings.quarter_3
    when StatisticReport.quarters[:quarter_4]
      Settings.quarter_4
    end
  end
end
