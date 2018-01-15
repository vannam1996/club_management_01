class CreateWarningReports < ActiveRecord::Migration[5.0]
  def change
    create_table :warning_reports do |t|
      t.integer :club_id
      t.text :messenger

      t.timestamps
    end
  end
end
