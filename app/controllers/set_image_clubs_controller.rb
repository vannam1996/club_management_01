class SetImageClubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club, only: [:show, :update]
  before_action :set_params_img, only: :update

  def show
    @list_images = @club.albums.includes(:images)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    set_crop
    if @club.update_attributes remote_image_url: @url_upload.to_s
      create_acivity @club, Settings.update, @club, current_user,
        Activity.type_receives[:club_member]
      flash[:success] = t "club_manager.club.success_update"
    else
      flash_error @club
    end
    redirect_to organization_club_path(@club.organization.slug, @club)
  end

  private
  def load_club
    @club = Club.find_by slug: params[:id]
    unless @club
      flash[:danger] = t "not_found"
      redirect_to root_url
    end
  end

  def set_params_img
    if params[:club].present?
      @url_upload = ENV["DOMAIN"] + params[:club][:image]
    else
      flash[:danger] = t "params_image_blank"
      redirect_to organization_club_path(@club.organization.slug, @club)
    end
  end

  def set_crop
    if params[:club]
      @club.set_attr_crop_image params[:club][:image_crop_x], params[:club][:image_crop_y],
        params[:club][:image_crop_h], params[:club][:image_crop_w]
    end
  end
end
