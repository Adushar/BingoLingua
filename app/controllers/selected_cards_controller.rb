class SelectedCardsController < ApplicationController
  before_action :validate_user
  before_action :set_card_and_test

  def select
    current_user.select_card @card_id

    respond_to do |format|
      format.js {
        render "select", :locals => {
          :user => current_user,
          :card_id => @card_id,
          :exist => current_user.has_selected_card?(@card_id)
        }
      }
    end
  end

  def unselect_all
    current_user.remove_selected_cards @test_id

    respond_to do |format|
      format.js { render "unselect" }
    end
  end

  private

  def validate_user
    render json: {}, status: 401 and return unless current_user
  end

  def set_card_and_test
    @test_id, @card_id = params[:test_id], params[:card_id]
  end
end
