class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string :name, unique: true
      t.string :code, unique: true
      t.references :user, index: true
      t.references :test, index: true
      t.string :flag
      t.timestamps
    end
    add_reference :users, :language, index: true
    add_reference :tests, :language, index: true
  end
end
