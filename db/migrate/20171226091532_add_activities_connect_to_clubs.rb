class AddActivitiesConnectToClubs < ActiveRecord::Migration[5.0]
  def change
    add_column :clubs, :activities_connect, :string
  end
end
