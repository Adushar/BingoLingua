class PageController < ApplicationController
  def index
    @page = Page.where(url: params[:url])
    if @page.empty?
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    else
      @page = @page.first
    end
  end
end
