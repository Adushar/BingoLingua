class LanguageController < ApplicationController
  before_action :authenticate_user!
  def update
    language = Language.find(params[:id])
    if language
      language.users << current_user
      if language.save
        flash[:notice] = "Your language now is set as #{language.name.downcase}"
        redirect_to root_path
      end
    end
  end
end
