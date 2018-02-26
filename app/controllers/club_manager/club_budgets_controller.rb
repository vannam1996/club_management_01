class ClubManager::ClubBudgetsController < BaseClubManagerController
  before_action :load_club
  before_action :load_event

  def index
    if params[:users].present?
      ActiveRecord::Base.transaction do
        params[:users].each do |user_id|
          @budget = Budget.create event_id: params[:event_id], user_id: user_id
        end
        @club.calculate_get_budget(@event, params[:users].size)
        params_money = {expense: @event.expense * params[:users].size * Settings.negative}
        create_service_and_update_money params_money
        flash[:success] = t("success_process")
      end
    end
    redirect_to :back
  end

  def create
    if @event
      @users = @club.users.yet_by_ids(@event.budgets.map(&:user_id))
    else
      @users = @club.users
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @budget_user = Budget.find_by event_id: params[:event_id],
      user_id: params[:user_id]
    if @budget_user
      if @budget_user.destroy
        @club.calculate_change_budget(@event)
        params_money = {expense: @event.expense}
        create_service_and_update_money params_money
        flash[:success] = t "success_process"
      else
        flash[:danger] = t "error_process"
      end
    else
      flash[:danger] = t("not_found_user_budget")
    end
    redirect_to :back
  end

  private
  def load_event
    @event = Event.find_by id: params[:event_id]
    unless @event
      flash[:danger] = t("event_not_found")
      redirect_to :back
    end
  end

  def create_service_and_update_money params_money
    service_money = UpdateClubMoneyService.new @event, @event.club, params_money
    service_money.update_first_money_of_event_get_money_member
  end
end
