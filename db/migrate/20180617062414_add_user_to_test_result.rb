class AddUserToTestResult < ActiveRecord::Migration[5.2]
  def change
    add_reference :test_results, :user, foreign_key: true
    add_reference :test_results, :test, foreign_key: true
  end
end
