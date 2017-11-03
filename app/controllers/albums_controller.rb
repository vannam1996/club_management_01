class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_album, only: :show

  def index
    @albums = @club.albums.newest.includes(:images)
  end

  def show
    @album_other = @club.albums.newest.other params[:id]
  end

  private
  def load_club
    @club = Club.friendly.find params[:club_id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def load_album
    @album = Album.find_by id: params[:id]
    unless @album
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end
end
