class AddNewColToMetrics < ActiveRecord::Migration[5.0]
  def change
    add_column :metrics, :metric_type, :string
  end
end
