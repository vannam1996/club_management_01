module ReportDetailsHelper
  def total_money details
    number_to_currency details.sum(&:money), locale: :vi
  end

  def count_money_detail report_detail, style
    total = Settings.default_money
    report_detail.detail.each do |key, value|
      total += value[:money].to_i if value[:style] == style
    end
    t("sum_label") + number_to_currency(total, locale: :vi).to_s
  end

  def view_total_pay_get_money array_detail
    array_pay_get = total_pay_get_money array_detail
    content_tag(:td, number_to_currency(array_pay_get.first, locale: :vi)) <<
      content_tag(:td, number_to_currency(array_pay_get.second, locale: :vi))
  end

  def last_money_of_event report_detail
    money = report_detail.first_money
    report_detail.detail.each do |key, value|
      if value[:style] == EventDetail.styles.key(Settings.style_event_detail.value_enum_pay)
        money -= value[:money].to_i
      elsif value[:style] == EventDetail.styles.key(Settings.style_event_detail.value_enum_get)
        money += value[:money].to_i
      end
    end
    money
  end

  def first_money array_detail
    number_to_currency array_detail.first.first_money, locale: :vi
  end

  def last_money array_detail
    first_money = array_detail.first.first_money
    array_detail.each do |detail|
      first_money += detail.money
    end
    number_to_currency first_money, locale: :vi
  end

  def view_by_style_details report_detail, style
    content_tag(:ul, class: "collapse", id: "detail-#{style}-#{report_detail.id}") do
      report_detail.detail.each do |key, value|
        if value[:style] == style
          concat content_tag(:li, value[:name] + ": " + number_to_currency(value[:money], locals: :vi))
        end
      end
    end
  end

  private

  def total_pay_get_money array_detail
    pay_total = Settings.default_money
    get_total = Settings.default_money
    array_detail.each do |report_detail|
      if report_detail.detail.is_a? Hash
        report_detail.detail.each do |key, value|
          if value[:style] == EventDetail.styles.key(Settings.style_event_detail.value_enum_pay)
            pay_total += value[:money].to_i
          elsif value[:style] == EventDetail.styles.key(Settings.style_event_detail.value_enum_get)
            get_total += value[:money].to_i
          end
        end
      end
    end
    [pay_total, get_total]
  end
end
