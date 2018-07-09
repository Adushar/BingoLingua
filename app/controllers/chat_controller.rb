class ChatController < ApplicationController
  before_action :authenticate_user!
  def index
    @activities = PublicActivity::Activity.all
    @activities.where("owner_id IS NOT NULL")
  end
end
