class AddColumnToActivitie < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :user_read, :text
  end
end
