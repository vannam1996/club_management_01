class AddUserIdToEvaluates < ActiveRecord::Migration[5.0]
  def change
    add_reference :evaluates, :user, foreign_key: true
  end
end
