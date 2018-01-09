class Support::StatisticReportSupport
  attr_reader :statistic_report

  def initialize club_ids, page, params_search
    @club_ids = club_ids
    @page = page
    @params_search = params_search
  end

  def report_pending
    StatisticReport.pending.search(@params_search).result
      .search_club(@club_ids).order_by_created_at.page(@page)
      .per Settings.per_page_statistic
  end

  def report_rejected
    StatisticReport.rejected.search(@params_search).result
      .search_club(@club_ids).order_by_created_at.page(@page)
      .per Settings.per_page_statistic
  end

  def report_approved
    StatisticReport.approved.search(@params_search).result
      .search_club(@club_ids).order_by_created_at.page(@page)
      .per Settings.per_page_statistic
  end

  def club_is_not_report
    StatisticReport.search_club(@club_ids)
  end
end
