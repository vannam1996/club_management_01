class CreateEventDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :event_details do |t|
      t.string :description
      t.integer :money, default: 0
      t.references :event, foreign_key: true
      t.timestamps
    end
  end
end
