class RelationshipsController < ApplicationController
  # before_action :check_guest, only: :create
  def create
    @user = User.find(params[:following_id])
    following = current_user.follow!(@user)
    if following.save
      flash[:success] = 'ユーザーをフォローしました'
      redirect_to @user
      @user.create_notification_follow!(current_user)
    else
      flash.now[:alert] = 'ユーザーのフォローに失敗しました'
      redirect_to @user
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).following
    following = current_user.unfollow!(@user)
    if following.destroy
      flash[:success] = 'ユーザーのフォローを解除しました'
      redirect_to @user
    else
      flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました'
      redirect_to @user
    end
  end
  
  # private
  #   def check_guest
  #     if current_user.email == 'guest@example.com'
  #       redirect_to missions_path, alert: 'ゲストユーザーはフォローできません。'
  #     end
  #   end

end
