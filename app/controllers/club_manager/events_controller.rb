class ClubManager::EventsController < BaseDashboardController
  before_action :load_club
  before_action :correct_manager
  before_action :load_event, except: [:index, :create, :new]

  def index
    unless @club
      flash[:danger] = t "cant_found_club"
      redirect_to club_manager_path
    end
    @events = @club.events.newest.page(params[:page]).per Settings.per_page_event
    @new_event = Event.new
  end

  def edit
    if @event.finished?
      flash[:danger] = t "event_is_finish"
      redirect_to :back
    end
  end

  def new
    @event = Event.new
  end

  def create
    event = Event.new event_params
    event.amount = @club.money
    if event.save
      create_acivity event, Settings.create, event.club, current_user,
        Activity.type_receives[:club_member]
      if params[:event][:event_category].to_i == Event.event_categories[:pay_money]
        @club.money_pay(params[:event][:expense].to_i)
      elsif params[:event][:event_category].to_i == Event.event_categories[:subsidy]
        @club.money_subsidy(params[:event][:expense].to_i)
      end
      flash[:success] = t "club_manager.event.success_create"
      redirect_to club_manager_club_path params[:club_id]
    else
      flash_error event
      redirect_to :back
    end
  end

  def update
    ActiveRecord::Base.transaction do
      if params[:event][:event_category].to_i == Event.event_categories[:pay_money]
        @club.pay_money_change(@event, params[:event][:expense])
      elsif params[:event][:event_category].to_i == Event.event_categories[:subsidy]
        @club.subsidy_money_change(@event, params[:event][:expense])
      end
      service = UpdateClubMoneyService.new @event, @club, event_params
      service.update_event
      service.update_money
      create_acivity @event, Settings.update, @event.club, current_user,
        Activity.type_receives[:club_member]
      flash[:success] = t "club_manager.event.success_update"
      redirect_to club_manager_club_event_path(id: @event.id)
    end
  rescue
    flash_error @event
    redirect_to :back
  end

  def show
    @news = News.new
    @users_done = @club.users.done_by_ids(@event.budgets.map(&:user_id))
    @users_yet = @club.users.yet_by_ids(@event.budgets.map(&:user_id))
  end

  private
  def load_event
    @event = Event.find_by id: params[:id]
    unless @event
      flash[:danger] = t "club_manager.event.not_found"
      redirect_to :back
    end
  end

  def load_club
    @club = Club.find_by id: params[:club_id]
    unless @club
      flash[:danger] = t "club_manager.club.not_found"
      redirect_to club_manager_club_albums_path params[:club_id]
    end
  end

  def event_params
    event_category = params[:event][:event_category].to_i
    params.require(:event).permit(:club_id, :name, :date_start, :status,
      :expense, :date_end, :location, :description, :image, :user_id)
      .merge! event_category: event_category
  end
end
