class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_event, only: [:show, :edit, :update, :destroy]
  before_action :event_is_inprocess, only: [:destroy, :edit]
  before_action :check_is_admin, only: [:new, :edit, :destroy]

  def new
    @event = Event.new
  end

  def create
    event = Event.new event_params_with_album
    event.amount = @club.money
    ActiveRecord::Base.transaction do
      event.save!
      create_acivity event, Settings.create, event.club, current_user,
        Activity.type_receives[:club_member]
      case params[:event][:event_category].to_i
      when Event.event_categories[:pay_money]
        @club.money_pay(params[:event][:expense].to_i)
      when Event.event_categories[:subsidy]
        @club.money_subsidy(params[:event][:expense].to_i)
      end
      flash[:success] = t "club_manager.event.success_create"
      redirect_to club_path params[:club_id]
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
      @comments = @event.comments.newest.take(Settings.limit_comments)
    end
  end

  def update
    ActiveRecord::Base.transaction do
      if params[:event][:event_category].to_i == Event.event_categories[:pay_money]
        @club.pay_money_change(@event, params[:event][:expense])
      elsif params[:event][:event_category].to_i == Event.event_categories[:subsidy]
        @club.subsidy_money_change(@event, params[:event][:expense])
      end
      club_money = UpdateClubMoneyService.new @event, @club, event_params
      club_money.update_event
      club_money.update_money
      create_acivity @event, Settings.update, @event.club, current_user,
        Activity.type_receives[:club_member]
      flash[:success] = t "club_manager.event.success_update"
      redirect_to club_event_path(club_id: params["club_id"], id: @event.id)
    end
  rescue
    flash[:danger] = t "error_in_process"
    redirect_to :back
  end

  def destroy
    update_money @event
    unless @event.destroy
      flash[:danger] = t "error_process"
      redirect_to organization_club_path @club.organization.slug, @club
    end
    flash[:success] = t "success_process"
    redirect_to organization_club_path @club.organization.slug, @club
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
      :expense, :date_end, :location, :description, :image, :user_id, :is_public)
      .merge! event_category: event_category
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
      event_params.merge! albums_attributes: [name: params[:event][:name],
        club_id: @club.id]
    else
      event_params
    end
  end

  def update_money event
    if event.get_money?
      event.club.update_attributes money: event.club.money - (event.budgets.size * event.expense.to_i)
    end
  end
end
