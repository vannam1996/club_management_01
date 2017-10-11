class AddColumnToClub < ActiveRecord::Migration[5.0]
  def change
    add_column :clubs, :slug, :string
  end
end
