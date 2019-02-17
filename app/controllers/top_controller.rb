class TopController < ApplicationController
  def index
    @top_users = User.all.order(:points).last(10).reverse
  end
end
