class Test < ApplicationRecord
  scope :free, -> (language) { where(free: true, language: [language, nil]) }
  scope :premium, -> (language) { where(free: false, language: [language, nil]) }
  scope :extra, -> (language) { where(promote: true, language: [language, nil]) }

  mount_uploader :picture, TestUploader
  # Relationships
  has_many :test_results
  has_many :cards
  has_and_belongs_to_many :groups
  belongs_to :language, optional: true

  def pack_name
    name.split("-")[0].gsub(/[^0-9]/, '').to_i
  end

  def often_shown_cards(user)
    return [] unless user.disappear_often_shown_cards?
    ShownCard.often_shown(user).where(card: cards).map(&:card)
  end
end
