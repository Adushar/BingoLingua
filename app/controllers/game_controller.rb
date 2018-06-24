class GameController < ApplicationController
  def index
    @free_tests = Test.where(free: true)
    @subscribe_tests = Test.where(free: false)
  end

  def show
    @test = Test.find(params[:id])
    @cards = gon.cards = @test.cards
    # Redirect if it isn`t free, user is logged in and subscribe is ended, but this user isn`t admin
    if ( !@test.free && current_user && !(User.subscribe_active(current_user.id)) && !current_user.admin? )
      render :file => "#{Rails.root}/public/pay.html",  layout: false
    end
    # Set up default cookie; get cookie and transform to integer
    cookies[:level] = { value: 1, :expires => 6.month.from_now } if !cookies.has_key?(:level)
    level = cookies[:level].to_i
    case level
    when 1
      gon.numer_of_tasks = 3
    when 2
      gon.numer_of_tasks = 4
    when 3
      gon.numer_of_tasks = 5
    when 4
      gon.selected_cards = User.find(current_user.id)
    end
  end
end
