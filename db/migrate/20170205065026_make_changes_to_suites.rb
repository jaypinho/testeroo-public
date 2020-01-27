class MakeChangesToSuites < ActiveRecord::Migration[5.0]
  def change
    remove_reference :suites, :metric, foreign_key: true
    add_reference :metrics, :suite, foreign_key: true
  end
end
