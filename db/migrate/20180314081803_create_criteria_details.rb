class CreateCriteriaDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :criteria_details do |t|
      t.references :criteria, foreign_key: true
      t.text :content
      t.float :points, default: 0

      t.timestamps
    end
  end
end
