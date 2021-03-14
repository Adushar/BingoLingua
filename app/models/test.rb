class Test < ApplicationRecord
  scope :free, -> { where(free: true) }
  scope :premium, -> { where(free: false) }
  scope :extra, -> { where(promote: true) }

  mount_uploader :picture, TestUploader
  # Relationships
  has_many :test_results
  has_many :cards
  has_and_belongs_to_many :groups
  has_many :points
  belongs_to :language, optional: true

  def pack_name
    name.split("-")[0].gsub(/[^0-9]/, '').to_i
  end

  def often_shown_cards(user)
    return [] unless user.disappear_often_shown_cards?
    ShownCard.often_shown(user).where(card: cards).map(&:card)
  end
end
