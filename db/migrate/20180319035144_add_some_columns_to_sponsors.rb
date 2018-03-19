class AddSomeColumnsToSponsors < ActiveRecord::Migration[5.0]
  def change
    add_column :sponsors, :money_receive, :float
    add_column :sponsors, :status_receive, :integer, default: 0
  end
end
