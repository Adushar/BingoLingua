class PersonalAccountController < ApplicationController
  before_action :authenticate_user!
  def index
    points = current_user.points
    @subscribe_days_left = current_user.subscribe_left
    @score = current_user.scores
    @result = {
      cards: nil,
      tests: current_user.test_results.distinct.pluck(:test_id).length,
      words: nil
    }
    @top_users = User.all.sort_by { |e| e.points.sum(:points) }.last(10).reverse
    @learned_words
  end
end
