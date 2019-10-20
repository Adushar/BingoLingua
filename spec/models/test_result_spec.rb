require 'rails_helper'

RSpec.describe TestResult, type: :model do
  describe "add_result" do
    before(:each) do
      # default params
      @test = FactoryBot.create(:test, :with_cards)
    end
    it 'creates new or updates existing' do
      TestResult.add_result(score: 72, test_id: @test.id, user_id: @user.id)
      TestResult.add_result(score: 0, test_id: @test.id, user_id: @user.id)
      TestResult.add_result(score: 53, test_id: @test.id, user_id: @user.id)
      TestResult.add_result(score: 100, test_id: @test.id, user_id: @user.id)
      @result = TestResult.find_by(test_id: @test.id, user_id: @user.id)

      # average
      expect(@result.score).to eq 56.25
      expect(@result.attempts).to eq 4
    end
  end
end
