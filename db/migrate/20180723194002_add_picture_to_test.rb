class AddPictureToTest < ActiveRecord::Migration[5.1]
  def change
    add_column :tests, :picture, :string, :default => ""
  end
end
