class AddCardsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :cards, :has_many
    add_column :cards, :users, :has_many
  end
end
