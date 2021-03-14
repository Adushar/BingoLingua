class LanguageController < ApplicationController
  def update
    user = current_user
    language = Language.find(params[:id])
    if language
      user.update(language: language) if user

      flash[:notice] = "Your language now is set as #{language.name.capitalize}"
      session[:language_code] = language.code
      redirect_to root_path
    end
  end
end
