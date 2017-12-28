class AddTypeToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :type_receive, :integer
  end
end
