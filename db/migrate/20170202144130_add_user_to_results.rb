class AddUserToResults < ActiveRecord::Migration[5.0]
  def change
    add_reference :results, :user, foreign_key: true
    add_column :results, :completed_at, :datetime
  end
end
