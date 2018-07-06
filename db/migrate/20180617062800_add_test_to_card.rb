class AddTestToCard < ActiveRecord::Migration[5.1]
  def change
    add_reference :cards, :test, index: true
  end
end
