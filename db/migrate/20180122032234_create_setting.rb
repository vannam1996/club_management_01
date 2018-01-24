class CreateSetting < ActiveRecord::Migration[5.0]
  def change
    create_table :organization_settings do |t|
      t.string :key
      t.integer :value
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
