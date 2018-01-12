class RatingsController < ApplicationController
  before_action :load_club, only: [:create, :rating_executed]

  def create
    ActiveRecord::Base.transaction do
      @club.ratings.build(user: current_user, star: params[:rating]).save!
      rating_executed
    end
    flash[:success] = t "you_raiting_club"
    respond_to do |format|
      format.js
    end
  end

  private
  def rating_executed
    unless @club.update_attributes rating: Rating.avg_rate(params[:rating], @club)
      flash[:danger] = t("not_rating")
      redirect_to root_url
    end
  end

  def rating_params
    params.permit :rating, :book_id
  end

  def load_club
    @club = Club.find_by(id: params[:club_id])
    unless @club
      flash[:danger] = t("not_found_club")
      redirect_to root_url
    end
  end
end
