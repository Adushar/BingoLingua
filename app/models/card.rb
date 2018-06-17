class Card < ApplicationRecord
  belongs_to :test
  has_and_belongs_to_many :users
end
