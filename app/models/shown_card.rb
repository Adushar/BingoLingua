class ShownCard < ApplicationRecord
  belongs_to :user
  belongs_to :card
  validates_uniqueness_of :user_id, :scope => [:card_id]

  scope :often_shown, -> (user) do
    where("appearance_number > ?", 30).where(user: user)
  end

  def self.add(user:, card:)
    existing_record = ShownCard.find_by(user: user, card: card)
    return ShownCard.create(user: user, card: card, appearance_number: 1) unless existing_record

    shown_times = existing_record.appearance_number
    shown_times += 1
    existing_record.update( appearance_number: shown_times )
  end

  def self.add_cards_set(user:, cards:)
    cards.each { |card| self.add(card: card, user: user) }
  end
end
