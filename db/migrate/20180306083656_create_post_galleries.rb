class CreatePostGalleries < ActiveRecord::Migration[5.0]
  def change
    create_table :post_galleries do |t|
      t.string :url
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
