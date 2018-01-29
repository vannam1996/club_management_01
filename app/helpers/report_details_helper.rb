module ReportDetailsHelper
  def check_key_details_style_money key
    ReportDetail.styles.keys[Settings.first_range_enum_money_in_report_details..
      Settings.last_range_enum_money_in_report_details].include? key
  end

  def total_money details
    number_to_currency details.sum(&:money), locale: :vi
  end

  def first_money array_detail
    number_to_currency array_detail.first.first_money, locale: :vi
  end

  def last_money array_detail
    first_money = array_detail.first.first_money
    array_detail.each do |detail|
      if detail.pay_money?
        first_money -= detail.money
      elsif detail.get_money?
        first_money += detail.money
      end
    end
    number_to_currency first_money, locale: :vi
  end
end
