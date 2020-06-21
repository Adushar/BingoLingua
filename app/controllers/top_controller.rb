class TopController < ApplicationController
  def index
    @top_users = Point.top_users.first(10)
  end
end
