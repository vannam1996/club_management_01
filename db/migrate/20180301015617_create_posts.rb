class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :name
      t.text :content
      t.references :user, foreign_key: true
      t.integer :target_id
      t.string :target_type
      t.timestamps
    end
  end
end
