require 'rails_helper'

RSpec.describe User, type: :model do
  context "while getting demo user" do
    it "show existing user" do
      user = FactoryBot.create(:user, :demo_mode)
      expect(User.demo_mode).to eq(user)
    end
    it 'create new user' do
      model_answer = User.demo_mode
      demo_user = User.find_by_email("demo_user@gmail.com")
      expect(model_answer).to eq(demo_user)
    end
  end
end
