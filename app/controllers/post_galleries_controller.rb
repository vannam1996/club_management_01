class PostGalleriesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_post, only: :index

  def index
    @galleries = @post.post_galleries if @post
  end

  private
  def load_post
    @post = Post.find_by id: params[:post_id]
    return if @post
    flash.now[:danger] = t "posts.cant_find_post"
  end
end
