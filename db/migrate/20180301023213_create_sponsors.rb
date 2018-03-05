class CreateSponsors < ActiveRecord::Migration[5.0]
  def change
    create_table :sponsors do |t|
      t.references :event, foreign_key: true
      t.text :purpose
      t.datetime :time
      t.text :place
      t.text :organizational_units
      t.text :participating_units
      t.text :experience
      t.text :communication_plan
      t.text :prize
      t.text :regulations
      t.float :expense, default: 0
      t.float :sponsor, default: 0
      t.text :interest
      t.timestamps
    end
  end
end
