class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end

    create_table :groups_users, id: false do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true
    end

    create_table :groups_tests, id: false do |t|
      t.belongs_to :group, index: true
      t.belongs_to :test, index: true
    end
  end
end
