require 'rails_helper'

RSpec.describe GameController, type: :controller do
  before(:each) do
    # default params
    @test = FactoryBot.create(:test, :with_cards)
    @cards = @test.cards.sample(3)
    @starting_score = @user.points ||= 0
  end

  describe "GET cards_set" do
    it 'returns random cards' do
      @request.cookies['level'] = @level = rand(1..3)
      get :cards_set, params: {id: @test.id, test_part: rand(1..4)}, format: :json

      expect(JSON.parse(response.body)["game"].length).to eq(@level+2)
    end
    it 'sends no data error' do
      @request.cookies['level'] = @level = 4
      get :cards_set, params: {id: @test.id, test_part: rand(1..4)}, format: :json
      expect(response.body).to be_json.with_content({
        :errors => 'You must select at least 4 cards by clicking on ☆'
      })
    end
    it 'sends crash error' do
      get :cards_set, params: {id: @test.id, test_part: rand(1..4)}, format: :json
      expect(response.body).to be_json.with_content({
        :errors => 'We can not download enough cards. Sorry us(⌣́_⌣̀)'
      })
    end
  end

  describe "GET check_answer" do
    before(:each) do
      # default params
      @request.session['correct_order'] = @cards.pluck(:id)
      @request.session['result'] = []
    end

    it "sends correct answer" do
      get :check_answer, :params => {
        :id => @test.id,
        :user_answer => @cards.pluck(:id)
       }, format: :json


       expect( response.body ).to be_json.with_content({
          :points => 1,
          :errors => nil
       })
       expect( @user.learned_words.pluck(:card_id) ).to include(*@cards.pluck(:id))   # Learned words are assigned to user
       expect( @user.test_results.last.score ).to eq(100)                       # New test result for our user is created
       expect( @user.points ).to eq(@starting_score+1)                          # Now user score is on 3 points more
    end

    it "sends 2 wrong and 1 correct answer" do
      wrong_answ = @cards.reverse

      get :check_answer, :params => {
        :id => @test.id,
        :user_answer => wrong_answ.pluck(:id)
      }, format: :json

      expect( response.body ).to be_json.with_content({
        :points => 0,                                                           # 0 for answer with mistake
        :errors => [
          JSON.parse(@cards.first.to_json),
          nil,
          JSON.parse(@cards.last.to_json)
        ]
      })
      expect( @user.learned_words.pluck(:card_id) ).to include(@cards[1].id)    # 1 learned word is assigned to user
      expect( @user.test_results.last.score.round ).to eq(33)                   # New test result for our user is created
      expect( @user.points ).to eq(@starting_score)
    end

    it "sends wrong answer" do
      wrong_answ = FactoryBot.create_list(:card, 3, test: @test)

      get :check_answer, :params => {
          :id => @test.id,
          :user_answer => wrong_answ.pluck(:id)
      }, format: :json
      expect(response.body).to be_json.with_content({
        :points => -1,                                                          # Minus one point for fully wrong answer
        :errors => JSON.parse(@cards.to_json)
      })
      expect( @user.test_results.last.score.round ).to eq(0)                   # New test result for our user is created
      expect( @user.points ).to eq(@starting_score-1)
    end
  end
end
