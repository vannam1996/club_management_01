class Dashboard::BudgetsController < BaseDashboardController
  before_action :load_club, only: :show
  def index
    @clubs = Club.of_user_clubs(current_user.user_clubs.manager)
  end

  def create
    ActiveRecord::Base.transaction do
      create_event
      params[:user_ids].split(",").each do |user_id|
        Budget.create! budget_params user_id
      end
      @event.cost_expense(params[:user_ids].split(",").size)
    end
    redirect_to dashboard_club_url(@club)
  end

  def show
    @event_clubs = @club.events.without_notification(Settings.notification).newest
    @events = @event_clubs.by_created_at params[:date_search][:first_date],
      params[:date_search][:second_date]
    if @events
      respond_to do |format|
        format.js
      end
    end
  end

  private
  def load_club
    @club = Club.friendly.find params[:id]
  rescue
    flash[:danger] = t "club_manager.cant_fount"
    redirect_to root_path
  end

  def create_event
    event_category = EventCategory.find_by id: Settings.periodic_category
    @event = event_category.events.of_month_payment(
      params[:month_of_payment].first
    ).find_by club_id: params[:club_id]
    flash[:info] = t("amount_event")
    return if @event
    @event = @club.events.build event_params
    if @event.save
      flash[:success] = t("event.success_create")
    else
      flash_error @event
    end
  end

  def budget_params user_id
    params.permit.merge! user_id: user_id, event_id: @event.id
  end

  def event_params
    params.permit(:amount).merge! user_id: current_user.id,
      name: Settings.payment_budget + params[:month_of_payment].first,
      location: @club.organization.location, description: params[:description].first,
      date_start: params[:month_of_payment].first.to_datetime.at_beginning_of_month,
      date_end: params[:month_of_payment].first.to_datetime.end_of_month,
      month_of_payment: params[:month_of_payment].first,
      event_category: Settings.periodic_category
  end
end
