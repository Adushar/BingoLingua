class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.references :test_result, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :points

      t.timestamps
    end
  end
end
