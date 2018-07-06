class CreateTestResults < ActiveRecord::Migration[5.1]
  def change
    create_table :test_results do |t|
      t.integer :attempts
      t.integer :last_result

      t.timestamps
    end
  end
end
