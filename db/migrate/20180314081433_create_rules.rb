class CreateRules < ActiveRecord::Migration[5.0]
  def change
    create_table :rules do |t|
      t.references :organization, foreign_key: true
      t.text :name

      t.timestamps
    end
  end
end
