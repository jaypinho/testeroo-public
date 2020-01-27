class CreateMetrics < ActiveRecord::Migration[5.0]
  def change
    create_table :metrics do |t|
      t.string :name
      t.text :definition
      t.string :ad_format
      t.string :environment
      t.integer :test_slots_count

      t.timestamps
    end
  end
end
