class AddDefaultValueForSubscribeToPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :subscribe_ends, :datetime
    add_column :users, :subscribe_ends, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
