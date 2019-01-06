require 'rails_helper'

RSpec.describe LearnedWord, type: :model do
  context "validation of user/card pair" do
    it "passed" do
      @rand_test = Test.last(5).sample(1)[0]
      @card = @rand_test.cards.sample(1)[0]

      learned_word = LearnedWord.new(card: @card, user: @user)
      expect(learned_word.save).to be(true)
    end
    it 'repeats' do
      @rand_test = Test.last(5).sample(1)[0]
      @card = @rand_test.cards.sample(1)[0]

      3.times do
        LearnedWord.create(card: @card, user: @user)
      end
      learned_word = LearnedWord.where(card: @card, user: @user)
      expect(learned_word[0].revise_times).to eq(2)
      expect(learned_word.count).to eq(1)
    end
    # LEARNED WORD REPEATS
  end
end
