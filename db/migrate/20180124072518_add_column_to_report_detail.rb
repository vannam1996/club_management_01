class AddColumnToReportDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :report_details, :money, :float
    add_column :report_details, :type, :string
    add_column :report_details, :first_money, :float
    add_column :report_details, :date_event, :datetime
  end
end
