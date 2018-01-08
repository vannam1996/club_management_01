class RemoveClubTypeFromClubRequest < ActiveRecord::Migration[5.0]
  def change
    remove_column :club_requests, :club_type, :integer
  end
end
