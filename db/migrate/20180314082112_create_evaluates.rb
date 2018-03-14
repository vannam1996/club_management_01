class CreateEvaluates < ActiveRecord::Migration[5.0]
  def change
    create_table :evaluates do |t|
      t.references :criteria_detail, foreign_key: true
      t.references :club, foreign_key: true
      t.integer :time
      t.float :total_points, default: 0
      t.integer :year

      t.timestamps
    end
  end
end
