class RemoveColumnToActivity < ActiveRecord::Migration[5.0]
  def change
    remove_column :activities, :deadline, :string
    remove_column :activities, :report_type, :string
  end
end
