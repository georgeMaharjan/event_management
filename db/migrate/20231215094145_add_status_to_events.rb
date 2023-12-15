class AddStatusToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :status, :integer
    add_index :events, :status
  end
end
