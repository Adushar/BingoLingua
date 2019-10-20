require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it { should have_one(:language) }
  context "while getting demo user" do
    it "show existing user" do
      user = FactoryBot.create(:user, :demo_mode)
      expect(User.demo_mode).to eq(user)
    end
    it 'create new user' do
      expect{User.demo_mode}.to change(User.all, :count).by(1)
    end
  end
  context "subscribe" do
    it "should be exprienced" do
      user = FactoryBot.create(:user)
      expect(user.subscribe_left).to eq("<b>Your subscription has ended</b>" )
    end
  end
end
