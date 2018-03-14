class DonatesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_event
  before_action :load_donate, only: [:edit, :show, :destroy, :update]
  before_action :donate_accept?, only: :update

  def new
    @donate = Donate.new
    respond_to do |format|
      format.js
    end
  end

  def create
    donate = Donate.new donate_params
    if donate.save
      flash[:success] = t "you_raiting_club"
    else
      flash[:errors] = t("error_process")
    end
    redirect_to club_event_path @club, @event
  end

  def edit
    @request = @donate.update_attributes status: params[:status]
    flash[:errors] = t("error_process") unless @request
    respond_to do |format|
      format.js
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def update
    if @donate.update_attributes expense: params[:donate][:expense]
      flash[:success] = t "donate.update_success"
    else
      flash[:errors] = t("error_process")
    end
    redirect_to club_event_path @club, @event
  end

  def destroy
    if @donate.accept?
      flash.now[:danger] = t "errors_delete"
    elsif @donate.destroy
      flash.now[:success] = t "delete_success"
    else
      flash.now[:danger] = t "error_process"
    end
    respond_to do |format|
      format.js
    end
  end

  private
  def load_event
    @event = Event.find_by id: params[:event_id]
    unless @event
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def load_club
    @club = Club.find_by slug: params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def load_donate
    @donate = Donate.find_by id: params[:id]
    unless @donate
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def donate_params
    params.require(:donate).permit :event_id, :user_id, :expense, :status
  end

  def donate_accept?
    if @donate.accept?
      flash[:errors] = t("donate.errors_update")
      redirect_to club_event_path @club, @event
    end
  end
end
