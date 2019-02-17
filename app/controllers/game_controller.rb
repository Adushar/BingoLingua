class GameController < ApplicationController
  before_action :demo_mode, only: :show, if: -> { Test.find(params[:id]).free && !current_user }
  def index
    language = current_user ? current_user.language : nil
    @free_tests = Test.where(free: true, language: [language, nil]).order('name').page(params[:free_tests]).per(15)
    @subscribe_tests = Test.where(free: false, language: [language, nil]).order('name').page(params[:subscribe_tests]).per(15)
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

  # AJAX request section

  def cards_set
    # Output: cards, selected, level
    level = cookies[:level].to_i                                                # Parse level
    test_id = params[:id].to_i
    test_part = params[:test_part].to_i
    if level == 4 && current_user                                               # Turn on selected mode
      cards = current_user.cards.where(test_id: test_id).sample(level)
      cards = [] if cards.length < 4
    elsif level >= 1
      level += 2
      cards = Test.find(test_id).cards                                          # Get all cards of this test
      cards = cards.limit(25*test_part).last(25).sample(level)                  # Get proper card block(0-25, 26-50, 51-75, 75-100)
    end
    if cards && !cards.empty?
      session[:correct_order] = cards.pluck(:id)
      @cards = cards.shuffle
      respond_to do |format|
        format.json { render :json => @cards }
      end
    else
      render :json => { :error => 'We can not download enough cards. Sorry us(⌣́_⌣̀)' }
    end
  end

  def check_answer
    cards = []
    user_answer = params[:user_answer]
    errors = find_errors(session[:correct_order], user_answer)                  # Find errors in answer. Add correct to LearnedWords
    session[:correct_order] = []                                                # Record to variable and clean
    if errors.compact.empty?                                                    # Has array other elements except nil?
      score_changes = 1
      errors = nil
    else
      score_changes = errors.include?(nil) ? 0 : -1                             # Remove point if answer is fully wrong
    end
    current_user.increment(:points, score_changes)

    respond_to do |format|
      format.json {
        render json: {
          :points => score_changes,
          :errors => errors
        }
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
      # Point.create(test_result: test_in_db, user: current_user, points: successful*( (cookies[:level].to_i||3)+2 )*10)
      respond_to do |format|
        format.json {
          render json: {:save => true}
        }
      end
    end
  end

  private

  def find_errors(usr_answ, corr_answ)
    errors = []
    if usr_answ.length == corr_answ.length
      usr_answ.each_with_index do |e,i|
        if e == JSON.parse(corr_answ[i])
          errors << nil
          LearnedWord.create(card_id: e, user: current_user)
        else
          errors << Card.find(e)
        end
      end
      return errors
    end
  end
end
