class AddStyleToReportCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :report_categories, :style, :integer, default: 3
  end
end
