class AddClubTypeIdToClubRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :club_requests, :club_type, index: true
  end
end
