class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :name
      t.references :album, foreign_key: true
      t.references :user, foreign_key: true
      t.string :video_file
      t.string :image_file
      t.integer :uploaded_size, default: 0
      t.boolean :is_success, default: false

      t.timestamps
    end
  end
end
