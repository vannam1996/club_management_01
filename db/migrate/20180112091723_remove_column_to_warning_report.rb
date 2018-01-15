class RemoveColumnToWarningReport < ActiveRecord::Migration[5.0]
  def change
    remove_column :warning_reports, :messenger, :string
  end
end
