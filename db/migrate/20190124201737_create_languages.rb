class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string :name, unique: true
      t.string :code, unique: true
      t.references :user, foreign_key: true
      t.references :test, foreign_key: true
      t.string :flag
      t.timestamps
    end
    add_column :users, :language_id, :integer
    add_column :tests, :language_id, :integer
  end
end
