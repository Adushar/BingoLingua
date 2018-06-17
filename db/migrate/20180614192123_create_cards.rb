class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :picture
      t.string :sound

      t.timestamps
    end
  end
end
