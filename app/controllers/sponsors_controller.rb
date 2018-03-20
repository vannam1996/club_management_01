class SponsorsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_sponsor, only: [:show, :edit, :destroy, :update]

  def new
    @sponsor = Sponsor.new
  end

  def index
    @sponsors = @club.sponsors.page(@page).per Settings.per_page_statistic
  end

  def create
    sponsor = Sponsor.new sponsor_params
    ActiveRecord::Base.transaction do
      if sponsor.save
        create_acivity sponsor, Settings.create_sponsor,
          @club.organization, current_user, Activity.type_receives[:organization_manager]
        flash[:success] = t ".create_success"
        redirect_to club_path @club
      else
        flash_error sponsor
        redirect_back fallback_location: new_club_sponsor_path(@club)
      end
    end
  rescue
    flash.now[:danger] = t ".errors_process"
    redirect_back fallback_location: new_club_sponsor_path(@club)
  end

  def update
    ActiveRecord::Base.transaction do
      if params[:sponsor]
        if @sponsor.update_attributes sponsor_params
          create_acivity @sponsor, Settings.update_sponsor,
            @club.organization, current_user, Activity.type_receives[:organization_manager]
          flash[:success] = t ".update_success"
          redirect_to club_path @club
        else
          flash_error sponsor
          redirect_back fallback_location: edit_club_sponsor_path(@club)
        end
      elsif @sponsor.confirm!
        flash[:success] = t ".confirm_success"
        redirect_to club_path @club
      end
    end
  rescue
    flash.now[:danger] = t ".errors_process"
    redirect_back fallback_location: edit_club_sponsor_path(@club)
  end

  def destroy
    if @sponsor.destroy
      flash[:success] = t "event_notifications.success_process"
    else
      flash[:danger] = t "event_notifications.error_in_process"
    end
  end

  private
  def sponsor_params
    experience = experience_params params
    params.require(:sponsor).permit(:event_id, :purpose, :time, :place,
      :organizational_units, :participating_units, :name_event,
      :communication_plan, :prize, :regulations, :expense, :sponsor, :interest).merge! experience: experience,
      club_id: @club.id, user_id: current_user.id, status: Sponsor.statuses[:pending]
  end

  def load_club
    @club = Club.friendly.find params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def load_sponsor
    @sponsor = Sponsor.find_by id: params[:id]
    unless @sponsor
      flash[:danger] = t "not_found"
      redirect_to club_path @club
    end
  end

  def experience_params params
    experience = {}
    params[:event].each.with_index do |event, index|
      experience.merge!({index.to_s.to_sym => {event: "#{event}", time_and_place: "#{params[:time][index]}",
        member: "#{params[:member][index]}", communication: "#{params[:communication][index]}"}})
    end
    experience
  end
end
