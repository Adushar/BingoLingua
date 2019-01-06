class PersonalAccountController < ApplicationController
  before_action :authenticate_user!
  def index
    points = current_user.points
    @subscribe_days_left = current_user.subscribe_left
    @score = current_user.scores
    @learned_words = LearnedWord.where(user: current_user)
    @result = {
      cards: @learned_words.count,
      tests: current_user.test_results.distinct.pluck(:test_id).count,
      repeats: @learned_words.sum(:revise_times)
    }
    @top_users = User.all.sort_by { |e| e.points.sum(:points) }.last(10).reverse
  end
end
