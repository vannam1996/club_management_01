class AddUrlVideoToPostGalleries < ActiveRecord::Migration[5.0]
  def up
    add_column :post_galleries, :url_video, :string
    add_column :post_galleries, :style, :integer
  end
end
