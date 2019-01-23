require 'rails_helper'

RSpec.describe MultipleLoadController, type: :controller do

  describe "POST #multiple_load" do
    before(:each) do
      # default params
      @dir_with_images = Dir.glob("public/uploads/*").sort.last.split("/").last # Last directory with images
      @path_name = @dir_with_images
      @test = FactoryBot.create(:test)
    end
    it "create cards" do
      post :create, :params => {path_name: @path_name, test: @test}
      sound_of_last_card = Dir.glob("public/uploads/#{@dir_with_images}/*.mp3").last
      # expect(response).to have_http_status(:success)
      expect(Card.last).not_to eq nil
      expect(sound_of_last_card).to include(Card.last.sound)
    end
  end

end
