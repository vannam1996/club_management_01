class SetUserDonatesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_event, only: [:update, :edit, :new, :show]
  before_action :load_user, only: :show

  def index
    @users = @club.users.load_infor_user params[:user]
    respond_to do |format|
      format.js
    end
  end

  def show
    @donate = Donate.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.find_by email: params[:email]
    if @user.present? && params[:expense].present?
      @donate = Donate.new(event_id: params[:event_id], user_id: @user.id,
        expense: params[:expense], status: Donate.statuses[:accept])
      unless @donate.save
        flash[:errors] = t("error_process")
      end
    else
      flash[:danger] = t "donate.unregistered"
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
      redirect_to club_path @club
    end
  end

  def load_club
    @club = Club.find_by slug: params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "not_found"
      redirect_to club_event_path @club, @event
    end
  end
end
