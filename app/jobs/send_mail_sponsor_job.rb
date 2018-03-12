class SendMailSponsorJob < ApplicationJob
  queue_as :email

  def perform sponsor
    @sponsor = sponsor
    SponsorMailer.mail_to_club_manager_sponsor(@sponsor).deliver_later
  end
end
