class PersonalAccountController < ApplicationController
  before_action :authenticate_user!
  def index
    @subscribe_days_left = current_user.subscribe_left
    @score = current_user.scores
    @monthly_score = current_user.monthly_score
    @learned_words = LearnedWord.where(user: current_user)
    @result = {
      cards: @learned_words.count,
      tests: current_user.test_results.distinct.pluck(:test_id).count,
      repeats: @learned_words.sum(:revise_times)
    }
    @top_users = Point.top_10_users
    @top_monthly_users = Point.top_10_users_monthly
  end
end
