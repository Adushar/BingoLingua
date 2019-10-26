class GameController < ApplicationController
  before_action :demo_mode, only: :show, if: -> { Test.find(params[:id]).free && !current_user }

  def index
    language = current_user ? current_user.language : nil

    @extra_tests = Test.extra(language).to_a
    @extra_tests = Kaminari.paginate_array(@extra_tests).page(params[:extra_tests]).per(15)

    @assigned_tests = current_user&.assigned_tests || []
    @assigned_tests = Kaminari.paginate_array(@assigned_tests).page(params[:assigned_tests]).per(15)

    @free_tests = Test.free(language).to_a.sort_by(&:pack_name)
    @free_tests = Kaminari.paginate_array(@free_tests).page(params[:free_tests]).per(15)

    @subscribe_tests = Test.premium(language).to_a.sort_by(&:pack_name)
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
    level = (cookies[:level] || 1).to_i                                           # Parse level
    test_part = (params[:test_part] || 1).to_i
    test_id = params[:id].to_i

    if level == 4 && current_user                                               # Turn on selected mode
      cards = current_user.selected_cards_by_test(test_id).sample(level)
      if cards.length < 4
        cards = []
        render :json => {
          :errors => 'You must select at least 4 cards by clicking on ☆'        # Send error
        }, :status => 422 and return                                            # Stop executing code
      end
    elsif level >= 1
      level += 2
      cards = Test.find(test_id).cards                                          # Get all cards of this test
      cards = cards.limit(25*test_part).last(25).sample(level)                  # Get proper card block(0-25, 26-50, 51-75, 75-100)
    end

    logger.debug "Rendering JSON answer for request"
    logger.debug "level: #{level}, test_part: #{test_part}, test_id: #{test_id}"
    logger.debug "user: #{current_user.id}, cards: #{cards.pluck(:id)}"

    if cards && !cards.empty?
      session[:correct_order] = cards.pluck(:id)
      @answer = cards
      @cards = cards.shuffle
      render :json => {
        game: @cards,
        answer: @answer
       } and return
    elsif not current_user
      error = "Please log in"
    else
      error = 'Not enough cards. Sorry(⌣́_⌣̀)'
    end

    render :json => {
      :errors => error
    }, :status => 422
  end

  def check_answer
    cards = []
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
      current_user.increment(:points, score_changes).save
      TestResult.add_result(                                                      # Send request to custom method in model with:
        score: 100-(errors_num.to_f/user_answer.length*100),                           # - Percent of correct answers(100%-error percrnt)
        test_id: params[:id],
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
