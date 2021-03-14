class LanguageController < ApplicationController
  before_action :authenticate_user!
  def update
    user = current_user
    language = Language.find(params[:id])
    if language
      user.language = language
      if user.save
        flash[:notice] = "Your language now is set as #{language.name.capitalize}"
        redirect_to root_path
      end
    end
  end
end
