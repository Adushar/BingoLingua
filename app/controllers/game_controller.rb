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
    gon.test_id = params[:id]
    gon.user_id = current_user.id if user_signed_in?
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

  def get_cards
    # Output: cards, selected, level
    level = cookies[:level].to_i                    # Parse level
    user_id = current_user.id.to_i
    test_id = params[:id].to_i
    test_part = params[:test_part].to_i
    if level == 4 && user_id   # Turn on selected mode
      cards = User.find(user_id).cards.where(test_id: test_id).sample(level)
    else
      level += 2
      cards = Test.find(test_id).cards                   # Get all cards of this test
      cards = cards.limit(25*test_part).last(25).sample(level)          # Get proper card block(0-25, 26-50, 51-75, 75-100)
    end
    session[:order] = cards.pluck(:id)
    mixed_cards = cards.shuffle.to_json(:include => {:users => {:only => [:id]}})
    cards = cards.to_json(:only => [:sound])      # Finaly transform to json
    respond_to do |format|
      format.json { render json: {"cards" => cards, "mixed_cards" => mixed_cards} }
    end
  end
  def check_answer
    cards = []
    correct_answer = session[:order]
    correct_answer.each do |answer|
      cards << Card.where(id: answer).pluck(:sound, :picture).first
    end
    cards = cards.to_json
    user_answer = JSON.parse(params[:user_answer])
    success = (correct_answer == user_answer ? true : false)
    compare_answers(correct_answer, user_answer)
    respond_to do |format|
      format.json {
        render json: {"success" => @success, "errors" => @errors, "cards" => cards}
      }
    end
  end

  private

  def compare_answers(arr1, arr2)
    if arr1 == arr2
      @success = true
    elsif arr1.length == arr2.length
      @success = false
      @errors = []
      arr1.each_with_index { |e, i| arr1[i] == arr2[i] ? @errors << true : @errors << false }
    end
  end
end
