class AddActiveToReportCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :report_categories, :status_active, :integer, default: 1
  end
end
