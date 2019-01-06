require 'rails_helper'

RSpec.describe GameController, type: :controller do
  describe "GET check_answer" do
    before(:each) do
      # default params
      @rand_test = Test.last(5).sample(1)[0]
      @cards = @rand_test.cards.sample(3)
      @request.session['order'] = @cards.pluck(:id)
      @request.session['result'] = []
    end

    it "sends correct answer" do
      @answer = {
        :success => true,
        :errors => nil,
        :cards => @cards.pluck(:sound, :picture).to_json
      }.as_json

      get :check_answer, :params => { :id => @rand_test.id, :user_answer => "#{@cards.pluck(:id)}" }, format: :json
      expect(response.body).to be_json.with_content(@answer)                                         # Check if algorithm works right
      expect( @user.learned_words.where(user_id: @user.id).pluck(:card_id) ).to eq(@cards.pluck(:id)) # Check if learned word is saved
    end

    it "sends 2 wrong and 1 correct answer" do
      wrong_answ = @cards.reverse

      @answer = {
        :success => false,
        :errors => [false, true, false],
        :cards => @cards.pluck(:sound, :picture).to_json
      }.as_json
      get :check_answer, :params => { :id => @rand_test.id, :user_answer => "#{wrong_answ.pluck(:id)}" }, format: :json
      expect(response.body).to be_json.with_content(@answer)
      expect( @user.learned_words.where(user_id: @user.id, card_id: @cards.pluck(:id)[1]) ).not_to be_empty # Check if learned word is saved
    end

    it "sends wrong answer" do
      wrong_answ = Test.first.cards.first(3)
      @answer = {
        :success => false,
        :errors => [false, false, false],
        :cards => @cards.pluck(:sound, :picture).to_json
      }.as_json

      get :check_answer, :params => { :id => @rand_test.id, :user_answer => "#{wrong_answ.pluck(:id)}" }, format: :json
      expect(response.body).to be_json.with_content(@answer)
    end
  end
end
