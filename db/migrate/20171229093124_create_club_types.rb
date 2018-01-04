class CreateClubTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :club_types do |t|
      t.references :organization, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
