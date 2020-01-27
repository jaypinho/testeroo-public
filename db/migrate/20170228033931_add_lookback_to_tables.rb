class AddLookbackToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :suites, :max_days_since_last_passed_test, :integer
    add_column :metrics, :max_days_since_last_passed_test, :integer
  end
end
