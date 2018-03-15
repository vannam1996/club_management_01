class CreateCriteriaDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :rule_details do |t|
      t.references :rule, foreign_key: true
      t.text :content
      t.float :points, default: 0

      t.timestamps
    end
  end
end
