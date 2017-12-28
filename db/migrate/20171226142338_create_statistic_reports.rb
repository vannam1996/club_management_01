class CreateStatisticReports < ActiveRecord::Migration[5.0]
  def change
    create_table :statistic_reports do |t|
      t.references :club
      t.references :user
      t.integer :style
      t.string :item_report
      t.string :detail_report
      t.string :plan_next_month
      t.integer :fund
      t.integer :members
      t.string :note
      t.string :others
      t.integer :time

      t.timestamps
    end
  end
end
