module StatisticReportsHelper
  def option_select option
    option.map{|k, v| [t("#{option}.#{k}"), v]}
  end
end
