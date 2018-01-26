class ChangeDataColumsInReportDetails < ActiveRecord::Migration[5.0]
  def up
    change_column :report_details, :type, :integer
    rename_column :report_details, :type, :style
  end
end
