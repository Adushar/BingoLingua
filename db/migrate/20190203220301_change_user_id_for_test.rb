class ChangeLangugeIdForTest < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :language_id, :integer, null: true
    change_column :tests, :language_id, :integer, null: true
  end
end
