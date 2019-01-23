class MultipleLoadController < ApplicationController
  before_action :is_admin?
  def new
    @test = Test.all
  end

  def create
    test = Test.find(params[:test])
    path_name = params[:path_name]

    files = Dir.glob("../../shared/public/uploads/#{path_name}/*.mp3")
    create_array = []
    files.each do |e|
      image_file = Dir.glob("../../shared/public/uploads/#{path_name}/#{filename}.*g").first
      sound = File.basename(e, ".*")
      filename = sound.gsub(".mp3", "")
      sound = sound.gsub(/\s+/, '%20')
      if !image_file.nil?
        image ||= File.basename(image_file).gsub(/\s+/, '%20')

        name_varients = filename.split("_")      # split "apple_яблоко" to array
        if name_varients.length > 1               # if translation present, add to database
          original = name_varients[0]
          translation = name_varients[1]
        else
        end
        puts original
        card = Card.new({
          picture: "/uploads/#{path_name}/#{image}",
          sound: "/uploads/#{path_name}/#{sound}",
          test: test,
          description: original,
          translation: translation
        })
        if !card.save
          @errors << card.errors.full_messages
        end

      end
    end
    respond_to do |format|
      if !files.empty? && @errors.nil?
        puts @errors
        format.html { redirect_to(new_multiple_load_path, :notice => 'Cards were successfully created.') }
      else
        format.html { redirect_to(new_multiple_load_path, :notice => 'Cards was not created. Check if you folder is not empty.') }
      end
    end
  end

  private

  # it will call before every action on this controller
  def is_admin?
    # check if user is a admin
    # if not admin then redirect to where ever you want
    redirect_to root_path unless current_user.admin?
  end
end
