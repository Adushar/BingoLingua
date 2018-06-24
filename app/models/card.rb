class Card < ApplicationRecord
  has_many :selected_cards
  has_many :users, :through => :selected_cards
  belongs_to :test
end
