class Card < ApplicationRecord
  has_many :selected_cards
  has_many :users, :through => :selected_cards
  has_many :learned_words
  has_one :language
  belongs_to :test, optional: true, foreign_key: 'test_id'
  # validates_presence_of :description
  # validates_presence_of :translation
end
