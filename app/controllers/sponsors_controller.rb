class SponsorsController < AlbumsController
  before_action :authenticate_user!
  before_action :user_signed_in
  before_action :load_club
  before_action :load_event

  def new
    if @event.sponsors.blank?
      @sponsor = Sponsor.new
    else
      flash[:success] = t "sponsors.new_errors"
      redirect_to club_event_path @club, @event
    end
  end

  def create
    sponsor = Sponsor.new sponsor_params
    if sponsor.save
      flash[:success] = t "success_process"
      redirect_to club_event_path @club, @event
    else
      flash_error sponsor
      redirect_back fallback_location: new_club_event_sponsor_path @club, @event
    end
  end

  private
  def sponsor_params
    experience = experience_params params
    params.require(:sponsor).permit(:event_id, :purpose, :time, :place,
      :organizational_units, :participating_units,
      :communication_plan, :prize, :regulations, :expense, :sponsor, :interest).merge! experience: experience,
      event_id: @event.id
  end

  def load_club
    @club = Club.friendly.find params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def load_event
    @event = Event.find_by id: params[:event_id]
    unless @event
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def experience_params params
    experience = {}
    params[:event].each.with_index do |event, index|
      experience.merge!({index.to_s.to_sym => {event: "#{event}", time_and_place: "#{params[:time][index]}",
        member: "#{params[:member][index]}", communication: "#{params[:communication][index]}"}})
    end
    experience
  end
end
