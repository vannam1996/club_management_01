class Support::StatisticReportSupport
  attr_reader :statistic_report

  def initialize club_ids, page
    @club_ids = club_ids
    @page = page
  end

  def report_pending
    StatisticReport.pending
      .search_club(@club_ids).order_by_created_at.page(@page)
      .per Settings.per_page_statistic
  end

  def report_rejected
    StatisticReport.rejected
      .search_club(@club_ids).order_by_created_at.page(@page)
      .per Settings.per_page_statistic
  end

  def report_approved
    StatisticReport.approved
      .search_club(@club_ids).order_by_created_at.page(@page)
      .per Settings.per_page_statistic
  end
end
