class EventNotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  authorize_resource class: false, through: :club
  before_action :load_event_notification, only: :update
  before_action :replace_string_in_money
  before_action :set_gon_varible, only: :new

  def show
    @events_notification = @club.events.newest
      .in_categories(Event.money_event_keys).page(params[:page]).per Settings.per_page
  end

  def new
    @event = @club.events.new
  end

  def create
    event = @club.events.new params_option
    event.amount = @club.money if event.activity_money?
    service_money = UpdateClubMoneyService.new event, @club, params_option
    ActiveRecord::Base.transaction do
      service_money.save_event_and_plus_money_club_in_activity_event
      flash[:success] = t ".create_success"
      redirect_to club_path params[:club_id]
    end
  rescue
    if event && event.errors.any?
      flash_error(event)
    else
      flash[:danger] = t ".error_in_process"
    end
    redirect_back fallback_location: new_club_event_notification_path(club_id: @club.id)
  end

  def update
    service_money = UpdateClubMoneyService.new @event, @club, params_option
    ActiveRecord::Base.transaction do
      service_money.update_first_money_of_event
      service_money.update_event_and_money_club_in_activity_event
      flash[:success] = t ".update_success"
      redirect_to club_event_path(club_id: @club.id, id: @event.id)
    end
  rescue
    if @event && @event.errors.any?
      flash_error @event
    else
      flash[:danger] = t ".error_process"
    end
    redirect_back fallback_location: edit_club_event_notification_path(club_id: @club.id,
      event: @event)
  end

  def destroy
    if @event && @event.destroy
      flash[:success] = t ".success_process"
      redirect_to organization_club_path @club.organization.slug, @club
    else
      flash[:danger] = t ".error_in_process"
      redirect_back fallback_location: club_path(club_id: @club.id)
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
    event_category = params[:event][:event_category].to_i
    params.require(:event).permit(:club_id, :name, :date_start, :status,
      :date_end, :location, :description, :image, :user_id, :is_public)
      .merge! event_category: event_category
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

  def params_option
    event_category = params[:event][:event_category].to_i
    case event_category
    when Event.event_categories[:notification]
      event_params_with_album
    else
      if params[:create_albums].present?
        event_params_with_attributes.merge! albums_attributes: [name: params[:event][:name],
          club_id: @club.id]
      else
        event_params_with_attributes
      end
    end
  end

  def event_params_with_attributes
    event_category = params[:event][:event_category].to_i
    count_money = CountMoney.new params[:event][:event_details_attributes]
    params.require(:event).permit(:club_id, :name, :date_start, :status,
      :date_end, :location, :description, :image, :user_id, :is_public,
      event_details_attributes: [:description, :money, :id, :_destroy, :style])
      .merge! event_category: event_category, expense: count_money.money,
      albums_attributes: [name: params[:event][:name], club_id: @club.id]
  end

  def replace_string_in_money
    if params[:event] && params[:event][:expense]
      params[:event][:expense].gsub!(",", "")
    end
    if params[:event] && params[:event][:event_details_attributes]
      params[:event][:event_details_attributes].each do |key, value|
        value[:money].gsub!(",", "") if value[:money]
        value[:style] = value[:style].to_i if value[:style]
      end
    end
  end

  def set_gon_varible
    gon.notification = Event.event_categories[:notification]
    gon.activity_money = Event.event_categories[:activity_money]
  end
end
