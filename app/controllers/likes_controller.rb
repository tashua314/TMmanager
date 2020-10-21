class LikesController < ApplicationController
  # before_action :private_user, only:[:create]
  before_action :set_variables
  before_action :mission_params

  def create
    @like = current_user.likes.create(:mission_id => params[:mission_id])
    @like.save
    redirect_back(:fallback_location => root_path)
    
    @mission = Mission.find(params[:mission_id])
    @mission.create_notification_like!(current_user)
      respond_to do |format|
        format.html { request.referrer }
        format.js
      end
  end

  def destroy
    @like = Like.find_by(:mission_id => params[:mission_id], :user_id => current_user.id)
    @like.destroy
    redirect_back(:fallback_location => root_path)
  end

  private
  # def private_user
  #   if current_user.email == 'guest@example.com'
  #     redirect_to missions_path, alert: 'ゲストユーザーはいいねできません。'
  #   end
  # end
  
  def set_variables 
    @mission = Mission.find(params[:mission_id])
    @id_name = "#like-link-#{@mission.id}"
  end

  def mission_params
    @mission = Mission.find(params[:mission_id])
  end
end
