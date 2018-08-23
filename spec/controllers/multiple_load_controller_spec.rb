require 'rails_helper'

RSpec.describe MultipleLoadController, type: :controller do

  describe "GET #multiple_load" do
    it "returns http success" do
      get :multiple_load
      expect(response).to have_http_status(:success)
    end
  end

end
