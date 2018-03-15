class AddParanoiaToAllTable < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :deleted_at, :datetime
    add_index :admins, :deleted_at
    add_column :budgets, :deleted_at, :datetime
    add_index :budgets, :deleted_at
    add_column :club_requests, :deleted_at, :datetime
    add_index :club_requests, :deleted_at
    add_column :clubs, :deleted_at, :datetime
    add_index :clubs, :deleted_at
    add_column :club_types, :deleted_at, :datetime
    add_index :club_types, :deleted_at
    add_column :comments, :deleted_at, :datetime
    add_index :comments, :deleted_at
    add_column :criteria, :deleted_at, :datetime
    add_index :criteria, :deleted_at
    add_column :criteria_details, :deleted_at, :datetime
    add_index :criteria_details, :deleted_at
    add_column :donates, :deleted_at, :datetime
    add_index :donates, :deleted_at
    add_column :evaluates, :deleted_at, :datetime
    add_index :evaluates, :deleted_at
    add_column :event_details, :deleted_at, :datetime
    add_index :event_details, :deleted_at
    add_column :events, :deleted_at, :datetime
    add_index :events, :deleted_at
    add_column :feed_backs, :deleted_at, :datetime
    add_index :feed_backs, :deleted_at
    add_column :messages, :deleted_at, :datetime
    add_index :messages, :deleted_at
    add_column :organization_requests, :deleted_at, :datetime
    add_index :organization_requests, :deleted_at
    add_column :organizations, :deleted_at, :datetime
    add_index :organizations, :deleted_at
    add_column :posts, :deleted_at, :datetime
    add_index :posts, :deleted_at
    add_column :reason_leaves, :deleted_at, :datetime
    add_index :reason_leaves, :deleted_at
    add_column :report_categories, :deleted_at, :datetime
    add_index :report_categories, :deleted_at
    add_column :report_details, :deleted_at, :datetime
    add_index :report_details, :deleted_at
    add_column :sponsors, :deleted_at, :datetime
    add_index :sponsors, :deleted_at
    add_column :statistic_reports, :deleted_at, :datetime
    add_index :statistic_reports, :deleted_at
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
    add_column :warning_reports, :deleted_at, :datetime
    add_index :warning_reports, :deleted_at
    add_column :evaluate_details, :deleted_at, :datetime
    add_index :evaluate_details, :deleted_at
  end
end
