class AddNameEventToReportDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :report_details, :name_event, :text
  end
end
