class AdNoteToRules < ActiveRecord::Migration[5.0]
  def change
    add_column :rules, :note, :text
  end
end
