class CreateReportService
  def initialize report_categorys, static_report
    @report_categorys = report_categorys
    @static_report = static_report
  end

  def create_report
    @report_detail = []
    @report_categorys.each do |report_category|
      if @static_report.monthly?
        @events = Event.by_event(report_category.style_event)
          .by_quarter(@static_report.time).by_years(@static_report.year)
      elsif @static_report.quarterly?
        quarter = SetQuarterReport.new @static_report.time
        @events = Event.by_event(report_category.style_event)
          .by_quarter(quarter.quarter_report).by_years(@static_report.year)
      end
      report_detail @events, @report_detail, report_category
    end
    @report_detail
  end

  private
  def report_detail events, report_detail, report_category
    @report_detail = report_detail
    if events.present?
      events.each do |event|
        @report_detail << save_report(event, report_category)
      end
    end
    return @report_detail
  end

  def save_report event, report_category
    ReportDetail.new(detail: event.name,
      statistic_report_id: @static_report.id, report_category_id: report_category.id,
      style: style_detail_report(event), money: money_detail_report(event), first_money: event.amount,
      date_event: event.created_at)
  end


  def style_detail_report event
    case
    when event.notification?
      :other
    when event.subsidy? || event.donate?
      :get_money
    else
      event.event_category
    end
  end

  def money_detail_report event
    if event.get_money?
      event.expense * event.budgets.size
    else
      event.expense
    end
  end
end