class Card < ApplicationRecord
  has_many :cards_users
  has_many :users, :through => :cards_users
  belongs_to :test
end
