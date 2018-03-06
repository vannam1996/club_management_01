class Support::SponsorSupport
  attr_reader :sponsor

  def initialize page, organization
    @page = page
    @organization = organization
  end

  def sponsor_pending
    @organization.sponsors.pending.page(@page).per Settings.per_page_statistic
  end

  def sponsor_reject
    @organization.sponsors.rejected.page(@page).per Settings.per_page_statistic
  end

  def sponsor_accept
    @organization.sponsors.accept.page(@page).per Settings.per_page_statistic
  end
end
