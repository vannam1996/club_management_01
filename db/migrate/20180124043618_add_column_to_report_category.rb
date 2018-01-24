class AddColumnToReportCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :report_categories, :style_event, :text
  end
end
