class CreateSelectedCards < ActiveRecord::Migration[5.2]
  def change
    create_table :selected_cards do |t|
      t.integer :user_id
      t.integer :card_id
    end
    add_index :selected_cards, [:user_id, :card_id]
  end
end
