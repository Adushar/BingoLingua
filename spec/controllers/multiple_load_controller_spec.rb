require 'rails_helper'

RSpec.describe MultipleLoadController, type: :controller do

  describe "POST #multiple_load" do
    before(:each) do
      # default params
      @dir_with_images = Dir.glob("public/uploads/*").sort[0...-2].last.split("/").last # Last directory with images
      @path_name = @dir_with_images
      @test = FactoryBot.create(:test)
    end

    it "creates cards" do
      post :create, :params => {path_name: @path_name, test: @test}
      sound_of_last_card = Dir.glob("public/uploads/#{@dir_with_images}/*.mp3").last

      expect(@test.cards.last).not_to eq nil
      expect(sound_of_last_card).to include(Card.last.sound)
    end
  end

end
