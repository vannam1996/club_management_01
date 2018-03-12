class AddUserIdToSponsor < ActiveRecord::Migration[5.0]
  def change
    add_column :sponsors, :user_id, :integer
  end
end
