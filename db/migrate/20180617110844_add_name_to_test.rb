class AddNameToTest < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :name, :string
  end
end
