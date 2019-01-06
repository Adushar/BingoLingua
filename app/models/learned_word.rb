class LearnedWord < ApplicationRecord
  belongs_to :user
  belongs_to :card
  after_rollback :uniqueness_of_pair, on: :create
  validates_uniqueness_of :user_id, :scope => [:card_id]

  private

  def uniqueness_of_pair
    pair = LearnedWord.where(user_id: user_id, card_id: card_id)
    if !pair.empty?
      learned_word = pair[0]
      revise_times = learned_word.revise_times.to_i.succ
      learned_word.revise_times = revise_times
      learned_word.save
    end
  end
end
