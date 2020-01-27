class AddJiraToResults < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :jira, :string
  end
end
