class AddCollumReportDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :report_details, :user_events, :text
  end
end
