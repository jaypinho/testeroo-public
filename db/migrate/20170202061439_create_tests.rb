class CreateTests < ActiveRecord::Migration[5.0]
  def change
    create_table :tests do |t|
      t.text :description
      t.text :expected_result
      t.string :test_link

      t.timestamps
    end
  end
end
