class ResetRepeatsController < ApplicationController
  def update
    return render :file => "public/401.html", :status => :unauthorized unless current_user&.admin?
    group = Group.find(params[:id])
    group.users.each do |user|
      ShownCard.where(user: user).destroy_all
    end

    return render inline: "Success. Card repeats for group '#{group.name}' was nullified"
  end
end
