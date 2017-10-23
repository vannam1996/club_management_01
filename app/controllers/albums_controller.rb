class AlbumsController < ClubsController
  before_action :authenticate_user!
  before_action :load_club

  def index
    @albums = @club.albums.newest.includes(:images)
  end

  def show
  end

  private
  def load_club
    @club = Club.friendly.find params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end
end
