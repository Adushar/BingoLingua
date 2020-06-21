class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.references :user
      t.integer :value, null: false
      t.references :test

      t.timestamps
    end
    remove_column :users, :points
  end
end
