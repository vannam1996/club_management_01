class AddClubTypeIdToClubs < ActiveRecord::Migration[5.0]
  def change
    add_reference :clubs, :club_type, index: true
  end
end
