class ChangeDataColumsStatisticreport < ActiveRecord::Migration[5.0]
  def up
    change_column :statistic_reports, :note, :text
    change_column :statistic_reports, :others, :text
    change_column :statistic_reports, :reason_reject, :text
    change_column :statistic_reports, :plan_next_month, :text
  end
end
