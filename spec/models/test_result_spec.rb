require 'rails_helper'

RSpec.describe TestResult, type: :model do
  describe "add_result" do
    before(:each) do
      # default params
      @test = FactoryBot.create(:test, :with_cards)
    end
    it 'creates new or updates existing' do
      TestResult.add_result(score: 72, test: @test, user: @user)
      TestResult.add_result(score: 0, test: @test, user: @user)
      TestResult.add_result(score: 53, test: @test, user: @user)
      TestResult.add_result(score: 100, test: @test, user: @user)
      @result = TestResult.find_by(test: @test, user: @user)

      # average
      expect(@result.score).to eq 56.25
      expect(@result.attempts).to eq 4
    end
  end
end
