class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.references :metric, foreign_key: true
      t.references :test, foreign_key: true
      t.integer :test_slot

      t.timestamps
    end
  end
end
