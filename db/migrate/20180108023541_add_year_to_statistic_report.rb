class AddYearToStatisticReport < ActiveRecord::Migration[5.0]
  def change
    add_column :statistic_reports, :year, :integer
  end
end
