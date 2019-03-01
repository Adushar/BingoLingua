class RenameLastResultToScore < ActiveRecord::Migration[5.1]
  def change
    rename_column :test_results, :last_result, :score
  end
end
