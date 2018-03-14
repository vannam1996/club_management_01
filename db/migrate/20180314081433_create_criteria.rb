class CreateCriteria < ActiveRecord::Migration[5.0]
  def change
    create_table :criteria do |t|
      t.references :organization, foreign_key: true
      t.text :name

      t.timestamps
    end
  end
end
