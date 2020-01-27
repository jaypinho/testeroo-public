class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :test, foreign_key: true
      t.boolean :passed
      t.text :note

      t.timestamps
    end
  end
end
