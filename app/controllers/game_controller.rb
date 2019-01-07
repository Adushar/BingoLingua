class GameController < ApplicationController
  def index
    @free_tests = Test.where(free: true).page(params[:free_tests]).per(15)
    @subscribe_tests = Test.where(free: false).page(params[:subscribe_tests]).per(15)
  end

  def show
    @test = Test.find(params[:id])
    @cards = @test.cards
    # If user isnt logged in
    if current_user.nil?
      redirect_to new_user_registration_url
    end
    # Redirect if it isn`t free, user is logged in and subscribe is ended, but this user isn`t admin
    if ( !@test.free && current_user && !(User.subscribe_active(current_user.id)) && !current_user.admin? )
      render :file => "#{Rails.root}/public/pay.html",  layout: false
    end
    # Set up default cookie; get cookie and transform to integer
    cookies[:level] = { value: 1, :expires => 12.month.from_now } if !cookies.has_key?(:level)
    gon.test_id = params[:id]
    gon.user_id = current_user.id if user_signed_in?
    session[:result] = []
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
      cards = [] if cards.length < 4
    else
      level += 2
      cards = Test.find(test_id).cards                   # Get all cards of this test
      cards = cards.limit(25*test_part).last(25).sample(level)          # Get proper card block(0-25, 26-50, 51-75, 75-100)
    end
    if cards
      session[:order] = cards.pluck(:id)
      mixed_cards = cards.shuffle.to_json(:include => {:users => {:only => [:id]}})
      puts [session[:order], mixed_cards]
      cards = cards.to_json(:only => [:sound])      # Finaly transform to json
    end
    respond_to do |format|
      format.json { render json: {"cards" => cards, "mixed_cards" => mixed_cards} }
    end
  end

  def check_answer
    cards = []
    correct_answer = session[:order]


    session[:order] = [] # Record to variable and clean
    correct_answer.each do |answer|
      cards << Card.where(id: answer).pluck(:sound, :picture).first
    end
    cards = cards.to_json
    user_answer = JSON.parse(params[:user_answer])
    success = (correct_answer == user_answer ? true : false)
    compare_answers(correct_answer, user_answer)
    learned_cards(correct_answer, user_answer)
    session[:result] << success
    respond_to do |format|
      format.json {
        render json: {"success" => @success, "errors" => @errors, "cards" => cards}
      }
    end
  end

  def finish_test
    user_id = current_user.id.to_i
    test_id = params[:id].to_i
    successful = session[:result].count(true)
    attempts = session[:result].length
    # Course of math by 5-th class
    percent_result = (successful*100)/attempts

    if session[:result_test_id] != params[:id] || TestResult.where(user_id: user_id, test_id: test_id).empty?
      test_in_db = TestResult.new(user_id: user_id, test_id: test_id)
      test_in_db.attempts = 1
      test_in_db.last_result = percent_result
    else
      test_in_db = TestResult.where(user_id: user_id, test_id: test_id).first
      # Dont touch. Dark magic is processing
      test_in_db.last_result = (test_in_db.last_result * test_in_db.attempts + percent_result )/(test_in_db.attempts+1)
      test_in_db.attempts += 1
    end
    if test_in_db.save
      session[:result_test_id] = params[:id]
      Point.create(test_result: test_in_db, user: current_user, points: successful*( (cookies[:level].to_i||3)+2 )*10)
      respond_to do |format|
        format.json {
          render json: {:save => true}
        }
      end
    end
  end

  private

  def learned_cards(arr1, arr2)
    if arr1 == arr2
      arr1.each { |e| LearnedWord.create(card_id: e, user: current_user) }
    elsif arr1.length == arr2.length
      @success = false
      @errors = []
      arr1.each_with_index do |e, i|
        if arr1[i] == arr2[i]
          @errors << true
          LearnedWord.create(card_id: arr1[i], user: current_user)
        else
          @errors << false
        end
      end
    end
  end

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
