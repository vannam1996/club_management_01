class AddStatusToSponsor < ActiveRecord::Migration[5.0]
  def change
    add_column :sponsors, :status, :integer, default: 0
    add_column :sponsors, :note, :text
  end
end
