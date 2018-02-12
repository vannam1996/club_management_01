class CreateReportService
  def initialize report_categorys, static_report, club
    @report_categorys = report_categorys
    @static_report = static_report
    @club = club
  end

  def create_report
    @report_detail = []
    @report_categorys.each do |report_category|
      if @static_report.monthly?
        @events = @club.events.by_event(report_category.style_event)
          .by_quarter(@static_report.time).by_years(@static_report.year)
      elsif @static_report.quarterly?
        quarter = SetQuarterReport.new @static_report.time
        @events = @club.events.by_event(report_category.style_event)
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
        if !report_category.member?
          events.each do |event|
            @report_detail << save_report(event, report_category)
          end
        else
          @report_detail << report_member(events, report_category)
        end
      end
    return @report_detail
  end

  def save_report event, report_category
    ReportDetail.new(detail: event.description,
      statistic_report_id: @static_report.id, report_category_id: report_category.id,
      style: style_detail_report(event), money: money_detail_report(event),
      first_money: event.amount, date_event: event.created_at, name_event: event.name,
      user_events: event.user_events.map(&:user_id))
  end

  def style_detail_report event
    case
    when event.notification?
      :other
    when event.subsidy? || event.donate? || event.receive_money?
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

  def report_member events, report_category
    ReportDetail.new(detail: save_report_member(events, report_category),
      statistic_report_id: @static_report.id, report_category_id: report_category.id,
      style: :other)
  end

  def save_report_member events, report_category
    detail = {};
    @club.user_clubs.each do |user_club|
      detail.merge!({user_club.user_id.to_s.to_sym => {name: "#{user_club.user.full_name}",
        size: LastMoney.count_event(user_club.user_id, events)}})
    end
    return detail.merge!(count_event: events.size)
  end
end
