class CreateReportDetail < ActiveRecord::Migration[5.0]
  def change
    create_table :report_details do |t|
      t.text :detail
      t.references :statistic_report, foreign_key: true
      t.references :report_category, foreign_key: true

      t.timestamps
    end
  end
end
