class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club, only: :index

  def index
    @messages = @club.messages.newest.limit(Settings.messages_load_more)
      .offset params[:num_message].to_i
  end

  private
  def load_club
    @club = current_user.clubs.find_by id: params[:id]
    return if @club && @club.is_active?
    flash[:danger] = t("club_is_lock")
    redirect_to clubs_url
  end
end
