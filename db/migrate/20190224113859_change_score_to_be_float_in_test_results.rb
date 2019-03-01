class ChangeScoreToBeFloatInTestResults < ActiveRecord::Migration[5.1]
  def up
    change_column :test_results, :score, :float, default: 0
  end
  def down
    change_column :test_results, :score, :integer, default: 0
  end
end
