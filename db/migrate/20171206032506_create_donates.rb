class CreateDonates < ActiveRecord::Migration[5.0]
  def change
    create_table :donates do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.float :expense
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
