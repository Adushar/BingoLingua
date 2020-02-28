class AddDissapearOftenShownCardsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :disappear_often_shown_cards, :boolean, :null => false, :default => true
  end
end
