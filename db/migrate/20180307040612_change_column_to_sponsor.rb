class ChangeColumnToSponsor < ActiveRecord::Migration[5.0]
  def change
    remove_reference :sponsors, :event, foreign_key: true
    add_reference :sponsors, :club, foreign_key: true
    add_column :sponsors, :name_event, :text
  end
end
