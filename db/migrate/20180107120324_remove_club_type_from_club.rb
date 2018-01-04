class RemoveClubTypeFromClub < ActiveRecord::Migration[5.0]
  def change
    remove_column :clubs, :club_type, :integer
  end
end
