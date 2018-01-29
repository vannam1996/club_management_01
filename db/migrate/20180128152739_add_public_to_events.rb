class AddPublicToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :is_public, :boolean, default: true
  end
end
