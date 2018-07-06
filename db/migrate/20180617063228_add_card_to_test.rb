class AddCardToTest < ActiveRecord::Migration[5.1]
  def change
    add_column :tests, :card, :has_many
    add_column :tests, :test_results, :has_many
  end
end
