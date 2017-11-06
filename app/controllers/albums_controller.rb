class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_album, only:[:show, :edit, :update, :destroy]

  def index
    @albums = @club.albums.newest.includes(:images)
  end

  def create
    album = Album.new album_params
    if album.save
      create_acivity album, Settings.create, album.club, current_user
      flash[:success] = t "club_manager.album.success_create"
    else
      flash_error album
    end
    redirect_to :back
  end

  def show
    @album_other = @club.albums.newest.other params[:id]
  end

  def destroy
    unless @album.destroy
      flash[:danger] = t "error_process"
    end
    flash[:success] = t "success_process"
    redirect_to :back
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @album.update_attributes album_params
      create_acivity @album, Settings.update, @album.club, current_user
      flash[:success] = t "club_manager.album.success_update"
    else
      flash_error @album
    end
    redirect_to :back
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

  def album_params
    params.require(:album).permit :club_id, :name
  end
end
