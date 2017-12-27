class CreateUserClubRequest < ActiveRecord::Migration[5.0]
  def change
    create_table :user_club_requests do |t|
      t.references :user, foreign_key: true
      t.references :club_request, foreign_key: true
      t.timestamps
    end
  end
end
