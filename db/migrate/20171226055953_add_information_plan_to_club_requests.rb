class AddInformationPlanToClubRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :club_requests, :activities_connect, :string
  end
end
