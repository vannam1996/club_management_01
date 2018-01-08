class AddStatusToStatisticReports < ActiveRecord::Migration[5.0]
  def change
    add_column :statistic_reports, :status, :integer
    add_column :statistic_reports, :reason_reject, :string
  end
end
