module ReportDetailsHelper
  def total_money details
    number_to_currency details.sum(&:money), locale: :vi
  end

  def total_pay_get_money array_detail
    pay_total = Settings.default_money
    get_total = Settings.default_money
    group_detail = array_detail.group_by &:style
    group_detail.each do |key, details|
      case key
      when Settings.key_pay_money_report_details
        pay_total = total_money details
      when Settings.key_get_money_report_details
        get_total = total_money details
      end
    end
    content_tag(:td, pay_total) << content_tag(:td, get_total)
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
