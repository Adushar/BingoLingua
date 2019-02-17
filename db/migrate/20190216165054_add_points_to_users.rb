class AddPointsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :points, :integer, default: 0
    drop_table :points do |t|
      t.references :test_result, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :points

      t.timestamps
    end
  end
  def up
    execute <<-SQL
      ALTER TABLE users ADD CONSTRAINT points CHECK (points >= 0);
    SQL
  end
end
