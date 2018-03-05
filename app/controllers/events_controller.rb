class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_event, only: [:show, :edit, :update, :destroy]
  before_action :event_is_inprocess, only: [:destroy, :edit]
  before_action :check_is_admin, only: [:new, :edit, :destroy]
  before_action :replace_string_in_money, only: [:create, :update]
  before_action :set_gon_varible, only: :new

  def new
    @event = Event.new
  end

  def create
    event = Event.new event_params_with_album
    event.amount = @club.money
    service_money = UpdateClubMoneyService.new event, @club, event_params_with_album
    ActiveRecord::Base.transaction do
      create_acivity event, Settings.create, event.club, current_user,
        Activity.type_receives[:club_member]
      service_money.save_event_and_plus_money_club_in_money_event
      flash[:success] = t "club_manager.event.success_create"
      redirect_to club_event_path params[:club_id], event.id
    end
  rescue
    if event.errors.any?
      flash_error event
    else
      flash[:danger] = t "events_club.error_in_process"
    end
    redirect_back fallback_location: new_club_event_path(club_id: @club.id)
  end

  def show
    @donate = Donate.new
    @expense_pending = @event.donate.pending.expense_pending
    @members = @event.users
    @members_done = @club.users.done_by_ids(@event.budgets.map(&:user_id))
    @members_yet = @club.users.yet_by_ids(@event.budgets.map(&:user_id))
    if params[:comment_status] == "all"
      @comments = @event.comments.newest
      respond_to do |format|
        format.js
      end
    else
      @comments = @event.comments.includes(:user).newest.take(Settings.limit_comments)
    end
    @posts = @event.posts.includes(:user, :post_galleries).newest.page(params[:page]).per Settings.per_page
    @post = Post.new
    load_member_not_join
  end

  def update
    ActiveRecord::Base.transaction do
      service_money = UpdateClubMoneyService.new @event, @club, event_params_with_album
      service_money.update_first_money_of_event
      service_money.update_event_and_money_club_in_money_event
      create_acivity @event, Settings.update, @event.club, current_user,
        Activity.type_receives[:club_member]
      flash[:success] = t "club_manager.event.success_update"
      redirect_to club_event_path(club_id: @club.id, id: @event.id)
    end
  rescue
    if @event && @event.errors.any?
      flash_error @event
    else
      flash[:danger] = t "event_notifications.error_process"
    end
    redirect_back fallback_location: edit_club_event_path(club_id: @club.id, event_id: @event)
  end

  def destroy
    if @event && @event.destroy
      flash[:success] = t "event_notifications.success_process"
      redirect_to organization_club_path @club.organization.slug, @club
    else
      flash[:danger] = t "event_notifications.error_in_process"
      redirect_back fallback_location: club_path(club_id: @club.id)
    end
  end

  private
  def load_club
    @club = Club.friendly.find params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def load_event
    @event = Event.find_by id: params[:id]
    unless @event
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def event_params
    params.require(:event).permit(:club_id, :name, :date_start, :status,
      :expense, :date_end, :location, :description, :image, :user_id, :is_public)
  end

  def check_is_admin
    unless @club.is_admin? current_user
      flash[:danger] = t "not_correct_manager"
      redirect_to root_url
    end
  end

  def event_is_inprocess
    if @event.finished?
      flash[:danger] = t "event_is_finish"
      redirect_to organization_club_path @club.organization.slug, @club
    end
  end

  def event_params_with_album
    if params[:create_albums].present?
      event_params_with_money_details.merge! albums_attributes: [name: params[:event][:name],
        club_id: @club.id]
    else
      event_params_with_money_details
    end
  end

  def event_params_with_money_details
    case params[:event][:event_category].to_i
    when Event.event_categories[:money]
      event_params_with_attributes
    else
      event_params.merge! event_category: params[:event][:event_category].to_i
    end
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

  def event_params_with_attributes
    event_category = params[:event][:event_category].to_i
    count_money = CountMoney.new params[:event][:event_details_attributes]
    params.require(:event).permit(:club_id, :name, :date_start, :status,
      :date_end, :location, :description, :image, :user_id, :is_public,
      event_details_attributes: [:description, :money, :id, :_destroy, :style])
      .merge! event_category: event_category, expense: count_money.money
  end

  def set_gon_varible
    gon.event_money = Event.event_categories.except(:notification, :activity_money)
  end
end
