class Card < ApplicationRecord
  has_many :selected_cards
  has_many :users, :through => :selected_cards
  has_many :learned_words
  belongs_to :test, optional: true, foreign_key: 'test_id'
end
