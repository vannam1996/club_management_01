class CreateEvaluateDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :evaluate_details do |t|
      t.references :rule_detail, foreign_key: true
      t.text :note

      t.timestamps
    end
  end
end
