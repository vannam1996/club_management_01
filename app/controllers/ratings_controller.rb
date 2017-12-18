class RatingsController < ApplicationController
  before_action :load_club, only: [:create, :rating_executed]

  def create
    if @club.ratings.find_by(user: current_user)
      flash[:danger] = t "you_rated"
    else
      ActiveRecord::Base.transaction do
        @club.ratings.build(user: current_user, star: params[:rating]).save
        rating_executed
        create_acivity @club, Settings.ratings, @club, current_user
      end
      flash[:success] = t "you_raiting_club"
    end
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
