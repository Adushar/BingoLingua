class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.boolean :free

      t.timestamps
    end
  end
end
