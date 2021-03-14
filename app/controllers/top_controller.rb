class TopController < ApplicationController
  def index
    @top_users = Point.top_10_users
    @top_monthly_users = Point.top_10_users_monthly
  end
end
