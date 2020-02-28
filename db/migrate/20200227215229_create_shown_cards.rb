class CreateShownCards < ActiveRecord::Migration[5.1]
  def change
    create_table :shown_cards do |t|
      t.references :user, foreign_key: true
      t.references :card, foreign_key: true
      t.integer :appearance_number, default: 0, null: false

      t.timestamps
    end
  end
end
