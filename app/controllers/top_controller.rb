class TopController < ApplicationController
  def index
    @top_users = Point.top_users.first(10)
    @top_monthly_users = Point.top_monthly_users.first(10)
  end
end
