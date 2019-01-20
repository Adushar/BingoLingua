class TopController < ApplicationController
  def index
    @top_users = User.all.sort_by { |e| e.points.sum(:points) }.last(10).reverse
  end
end
