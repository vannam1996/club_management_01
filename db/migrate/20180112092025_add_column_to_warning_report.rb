class AddColumnToWarningReport < ActiveRecord::Migration[5.0]
  def change
    add_column :warning_reports, :style, :integer
    add_column :warning_reports, :time, :integer
    add_column :warning_reports, :year, :integer
    add_column :warning_reports, :deadline, :datetime
    add_column :warning_reports, :user_read, :text
  end
end
