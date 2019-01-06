class CreateLearnedWords < ActiveRecord::Migration[5.1]
  def change
    create_table :learned_words do |t|
      t.references :user, foreign_key: true
      t.references :card, foreign_key: true
      t.integer :revise_times

      t.timestamps
    end
  end
end
