class CreateCriterias < ActiveRecord::Migration[5.0]
  def change
    create_table :rules do |t|
      t.references :organization, foreign_key: true
      t.text :name
      t.text :note

      t.timestamps
    end
  end
end
