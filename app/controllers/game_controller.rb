class GameController < ApplicationController
  before_action :demo_mode, only: :show, if: -> { Test.find(params[:id]).free && !current_user }

  def index
    @extra_tests = Test.extra.to_a
    @extra_tests = Kaminari.paginate_array(@extra_tests).page(params[:extra_tests]).per(15)

    @assigned_tests = current_user&.assigned_tests || []
    @assigned_tests = Kaminari.paginate_array(@assigned_tests).page(params[:assigned_tests]).per(15)

    @free_tests = Test.free.to_a.sort_by(&:pack_name) if current_user&.groups.blank?
    @free_tests ||= []
    @free_tests = Kaminari.paginate_array(@free_tests).page(params[:free_tests]).per(15)
  end

  def premium
    @subscribe_tests = Test.premium.to_a.sort_by(&:pack_name) if current_user&.groups.blank?
    @subscribe_tests ||= []

    @subscribe_tests = Kaminari.paginate_array(@subscribe_tests).page(params[:subscribe_tests]).per(15)
  end

  def show
    @test = Test.find(params[:id])
    @cards = @test.cards.order(:position_in_test)
    # If user isnt logged in
    if current_user.nil?
      redirect_to new_user_registration_url
    end
    # Redirect if it isn`t free, user is logged in and subscribe is ended, but this user isn`t admin
    if ( !@test.free && current_user && !(User.subscribe_active(current_user.id)) && !current_user.admin? )
      render :file => "#{Rails.root}/public/pay.html",  layout: false
      return
    end
    # Set up default cookie; get cookie and transform to integer
    cookies[:level] = { value: 1, :expires => 12.month.from_now } if !cookies.has_key?(:level)
    gon.test_id = params[:id]
    gon.user_id = current_user.id if user_signed_in?
    session[:result] = []
  end

  def update

  end

  # AJAX request section

  def cards_set
    # Output: cards, selected, level
    level = cookies[:level].to_i                                                # Parse level
    level = 1 if level < 1
    test_part = (params[:test_part] || 1).to_i
    test = Test.find(params[:id].to_i)

    if level == 4 && current_user                                               # Turn on selected mode
      cards = current_user.cards.where(test: test)
      cards = remove_often_shown_cards(cards, test)
      cards = cards.sample(level)
      if cards.length < 4
        cards = []
        render :json => {
          :errors => 'You must select at least 4 cards by clicking on ☆'        # Send error
        }, :status => 422 and return                                            # Stop executing code
      end
    elsif level >= 1
      level += 2
      cards = test.cards.order(:position_in_test)                               # Get all cards of this test
      cards = cards.first(25*test_part).last(25)                                # Get proper card block(0-25, 26-50, 51-75, 75-100)
      cards = remove_often_shown_cards(cards, test)
      cards = cards.sample(level)                                               # Select N random
    end

    logger.debug "Rendering JSON answer for request"
    logger.debug "level: #{level}, test_part: #{test_part}, test_id: #{test.id}"
    logger.debug "user: #{current_user&.id}, cards: #{cards.pluck(:id)}"

    if not current_user
      error = "Please log in"
    elsif cards && !cards.empty?
      session[:correct_order] = cards.pluck(:id)
      @answer = cards
      @cards = cards.shuffle
      ShownCard.add_cards_set(cards: @cards, user: current_user)
      render :json => {
        game: @cards,
        answer: @answer
       } and return
    else
      error = 'Cards in this part are over. Move to the next one'
    end

    render :json => {
      :errors => error
    }, :status => 422
  end

  def check_answer
    cards = []
    test_id = params[:id]
    user_answer = params[:user_answer]
    errors = find_errors(session[:correct_order], user_answer)                  # Find errors in answer. Add correct to LearnedWords
    session[:correct_order] = []                                                # Clean session parameter
    errors_num = errors.compact.length

    if current_user
      if errors_num == 0                                                         # Is array fully correct?
        score_changes = 1
        errors = nil
      else
        score_changes = errors.include?(nil) ? 0 : -1                             # Remove point if answer is fully wrong
      end
      Point.create!(test_id: test_id, user: current_user, value: score_changes)
      TestResult.add_result(                                                      # Send request to custom method in model with:
        score: 100-(errors_num.to_f/user_answer.length*100),                           # - Percent of correct answers(100%-error percrnt)
        test_id: test_id,
        user_id: current_user.id
      )
    else
      error = "Please log in"
    end

    respond_to do |format|
      format.json {
        render json: {
          :points => score_changes,
          :errors => errors
        }
      }
    end
  end

  private

  def often_shown_cards(user:, test:)
    return [] if user.demo_user?

    test.often_shown_cards(user)
  end

  def remove_often_shown_cards(cards, test)
    cards - often_shown_cards(user: current_user, test: test)
  end

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
