class ClubManager::EvaluatesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :all_evaluates
  before_action :load_evaluate, only: :show
  authorize_resource

  def index; end

  def show; end

  private
  def load_club
    @club = Club.find_by slug: params[:club_id]
    return if @club
    flash[:danger] = t ".club_not_found"
  end

  def all_evaluates
    if @club
      @evaluates = @club.evaluates.newest.page(params[:page]).per Settings.per_page
    end
  end

  def load_evaluate
    if @club
      @evaluate = Evaluate.includes(:evaluate_details).find_by id: params[:id]
      return if @evaluate
      flash[:danger] = t ".evaluate_not_found"
    end
  end
end
