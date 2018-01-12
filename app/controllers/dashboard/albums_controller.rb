class Dashboard::AlbumsController < BaseDashboardController
  before_action :load_club
  before_action :correct_manager
  before_action :load_album, except: [:index, :create]

  def index
    @albums = @club.albums.newest.page(params[:page]).per Settings.per_page_album
    @new_album = Album.new
  end

  def show
    @images = @album.images.newest.page(params[:page]).per Settings.per_page_image
    @image = Image.new
  end

  def create
    album = Album.new album_params
    if album.save
      create_acivity album, Settings.create, album.club, current_user,
        Activity.type_receives[:club_member]
      flash[:success] = t "club_manager.album.success_create"
    else
      flash_error album
    end
    redirect_to :back
  end

  def destroy
    unless @album.destroy
      flash[:danger] = t "error_process"
      redirect_to :back
    end
    flash[:success] = t "success_process"
    redirect_to :back
  end

  def edit
  end

  def update
    if @album.update_attributes album_params
      create_acivity @album, Settings.update, @album.club, current_user,
        Activity.type_receives[:club_member]
      flash[:success] = t "club_manager.album.success_update"
    else
      flash_error @album
    end
    redirect_to :back
  end

  private
  def load_album
    @album = Album.find_by id: params[:id]
    unless @album
      flash[:danger] = t "club_manager.album.not_found"
      redirect_to dashboard_club_albums_path params[:club_id]
    end
  end

  def load_club
    @club = Club.friendly.find params[:club_id]
    unless @club
      flash[:danger] = t "club_manager.club.not_found"
      redirect_to dashboard_club_albums_path params[:club_id]
    end
  end

  def album_params
    params.require(:album).permit :club_id, :name
  end
end
