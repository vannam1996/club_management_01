class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club, only:[:show, :new, :create, :check_is_admin]
  before_action :load_event, only: :show
  before_action :check_is_admin, only: :new

  def new
    @event = Event.new
  end

  def create
    event = Event.new event_params
    event.amount = @club.money
    if event.save
      create_acivity event, Settings.create, event.club, current_user
      case params[:event][:event_category].to_i
      when Event.event_categories[:pay_money]
        @club.money_pay(params[:event][:expense].to_i)
      when Event.event_categories[:subsidy]
        @club.money_subsidy(params[:event][:expense].to_i)
      end
      flash[:success] = t "club_manager.event.success_create"
      redirect_to club_path params[:club_id]
    else
      flash_error event
      redirect_to :back
    end
  end

  def show
    @members = @event.users
    @members_done = @club.users.done_by_ids(@event.budgets.map(&:user_id))
    @members_yet = @club.users.yet_by_ids(@event.budgets.map(&:user_id))
    if params[:comment_status] == "all"
      @comments = @event.comments.newest
      respond_to do |format|
        format.js
      end
    else
      @comments = @event.comments.newest.take(Settings.limit_comments)
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
    event_category = params[:event][:event_category].to_i
    params.require(:event).permit(:club_id, :name, :date_start, :status,
      :expense, :date_end, :location, :description, :image, :user_id)
      .merge! event_category: event_category
  end

  def check_is_admin
    unless @club.is_admin? current_user
      flash[:danger] = t "not_correct_manager"
      redirect_to root_url
    end
  end
end
