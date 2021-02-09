class Card < ApplicationRecord
  has_many :selected_cards, dependent: :destroy
  has_many :users, :through => :selected_cards
  has_many :learned_words, dependent: :nullify
  has_many :shown_cards, dependent: :nullify
  has_one :language
  belongs_to :test, optional: true, foreign_key: 'test_id'
  # validates_presence_of :description
  # validates_presence_of :translation

  def repeats_for(user:)
    shown_cards.where(user: user).pluck(:appearance_number).sum
  end
end
