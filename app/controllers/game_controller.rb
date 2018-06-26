class GameController < ApplicationController
  def index
    @free_tests = Test.where(free: true)
    @subscribe_tests = Test.where(free: false)
  end

  def show
    @test = Test.find(params[:id])
    @cards = @test.cards
    # Redirect if it isn`t free, user is logged in and subscribe is ended, but this user isn`t admin
    if ( !@test.free && current_user && !(User.subscribe_active(current_user.id)) && !current_user.admin? )
      render :file => "#{Rails.root}/public/pay.html",  layout: false
    end
    # Set up default cookie; get cookie and transform to integer
    cookies[:level] = { value: 1, :expires => 12.month.from_now } if !cookies.has_key?(:level)
    gon.level_dafault = cookies[:level].to_i
    gon.test_id = params[:id]
    #gon.cards = Card.where(test: params[:id])
    #gon.selected = Card.where(users: current_user.id) if cookies[:level] == 4
  end

  def update
    if current_user
      user = User.find(current_user.id)
      card = Card.find(params[:card_id])
      if !user.cards.exists?(params[:card_id])
        user.cards << card
      else
        user.cards.destroy(card)
      end
      respond_to do |format|
        format.js { render "update", :locals => {:user => user, :card => card, :exist => user.cards.exists?(params[:card_id])} }
        format.json { render json: user, status: :updated }
      end
    end
  end
end
