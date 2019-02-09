require 'rails_helper'

RSpec.describe LanguageController, type: :controller do
  describe "PATCH #update" do
    it "returns http success" do
      patch :update, params: { id: FactoryBot.create(:language) }
      expect(response).to have_http_status(:redirect)
    end

    it "redirects to sign in page" do
      sign_out @user
      patch :update, params: { id: FactoryBot.create(:language) }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
