class EventNotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  authorize_resource class: false, through: :club
  before_action :load_event_notification, only: :update

  def new
    @event = @club.events.new
  end

  def create
    event = @club.events.new merge_event_category_params
    if event.save
      flash[:success] = t ".create_success"
      redirect_to club_path params[:club_id]
    else
      flash_error event
      redirect_back fallback_location: new_club_event_notification_path(club_id: @club.id)
    end
  end

  def update
    if @event.update_attributes event_params_with_album
      flash[:success] = t ".update_success"
      redirect_to club_event_path(club_id: @club.id, id: @event.id)
    else
      flash_error @event
      redirect_back fallback_location: edit_club_event_notification_path(club_id: @club.id,
        event: @event)
    end
  end

  private
  def load_club
    @club = Club.friendly.find params[:club_id]
    unless @club
      flash[:danger] = t ".error_find_club"
      redirect_to root_url
    end
  end

  def event_notification_params
    params.require(:event).permit(:club_id, :name, :date_start, :status,
      :date_end, :location, :description, :image, :user_id, :is_public)
  end

  def merge_event_category_params
    event_category = params[:event][:event_category].to_i
    event_params_with_album.merge! event_category: event_category
  end

  def event_params_with_album
    if params[:create_albums].present?
      event_notification_params.merge! albums_attributes: [name: params[:event][:name],
        club_id: @club.id]
    else
      event_notification_params
    end
  end

  def load_event_notification
    @event = Event.find_by id: params[:id]
    return if @event
    flash[:danger] = t ".error_find_event"
    redirect_to root_url
  end
end
