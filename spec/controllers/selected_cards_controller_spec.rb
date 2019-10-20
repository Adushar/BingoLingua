require 'rails_helper'

RSpec.describe SelectedCardsController, type: :controller do
  render_views
  before(:each) do
    @test = FactoryBot.create(:test, :with_cards)
    @card1, @card2, @card3 = @test.cards.first(3)
    @select_card1 = SelectedCard.create(user: @user, card: @card1)
    @select_card2 = SelectedCard.create(user: @user, card: @card2)
  end

  describe "POST #select" do
    it "selects card" do
      expect {
        post :select, params: {test_id: @test.id, card_id: @card3.id}, format: :js
      }.to change(@user.selected_cards, :count).from(2).to(3)
    end
  end

  describe "DELETE #unselect_all" do
    it "deletes all cards related to test" do
      expect {
        delete :unselect_all, params: {test_id: @test.id}, format: :js
      }.to change(@user.selected_cards, :count).from(2).to(0)
    end
  end

end
