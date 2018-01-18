class AddStatusToReportCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :report_categories, :status, :integer
    add_reference :report_categories, :organization, index: true
  end
end
