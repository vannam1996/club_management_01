class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event, only: %i(index create destroy)
  before_action :load_post, except: %i(create index)
  authorize_resource

  def create
    @post = current_user.posts.new post_params
    if @post.save
      flash.now[:success] = t ".create_success"
    elsif @post.errors.any?
      flash.now[:danger] = @post.errors.full_messages
    else
      flash.now[:success] = t ".create_errors"
    end
    redirect_to club_event_path(@event, club_id: @event.club.slug)
  end

  def show; end

  def index
    all_post
    @post = Post.new
  end

  def edit; end

  def update
    if @post.update_attributes post_update_params
      flash[:success] = t ".update_success"
    elsif @post.errors.any?
      flash[:danger] = @post.errors.full_messages
    else
      flash[:success] = t ".update_errors"
    end
    redirect_to post_path @post
  end

  def destroy
    if @post.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:success] = t ".destroy_errors"
    end
    redirect_to club_event_path(@event, club_id: @event.club.slug)
  end

  private

  def post_params
    params.require(:post).permit :name, :content, :target_id, :target_type,
      post_galleries_attributes: [:url]
  end

  def post_update_params
    params.require(:post).permit :name, :content,
      post_galleries_attributes: [:url, :_destroy]
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post
    flash.now[:danger] = t ".cant_find_post"
    redirect_to root_path
  end

  def load_event
    @event = Event.find_by id: params[:event_id]
    return if @event
    flash.now[:danger] = t ".cant_find_event"
    redirect_to root_path
  end

  def all_post
    @posts = @event.posts.includes(:user).newest.page(params[:page]).per Settings.per_page
  end
end
