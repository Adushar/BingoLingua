class AddPostionInTestToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :position_in_test, :integer
  end
end
