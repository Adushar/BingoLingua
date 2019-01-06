class AddTranslationToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :translation, :string
    add_column :cards, :description, :string
  end
end
