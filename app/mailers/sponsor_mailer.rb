class SponsorMailer < ApplicationMailer
  def mail_to_club_manager_sponsor sponsor
    @sponsor = sponsor
    @user = @sponsor.user
    @club = @sponsor.club
    @url = Settings.my_url
    mail to: @user.email, subject: t("sponsors.sponsors")
  end
end
