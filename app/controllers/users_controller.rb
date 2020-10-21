class UsersController < ApplicationController
  before_action :authenticate_user!, :only => [:show]
  # before_action :private_user, :only => [:show]
  def index
    @users = User.all
  end

  def show
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    @user=User.find(params[:id])
    @currentUserEntry=Entry.where(:user_id => current_user.id)
    @userEntry=Entry.where(:user_id => @user.id)
    if @user.id == current_user.id && current_user.email != 'guest@example.com'
      # @msg ="他のユーザーとDMしてみよう！"
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom != true
        @room = Room.new
        @entry = Entry.new
      end
    end
    @mission = Mission.where(:user_id => @user.id)
    @notclearmission = Mission.where(:completed => 0, :user_id => @user.id) 
    @clearmission = Mission.where(:completed => 1, :user_id => @user.id)
    @mission.count
  end

  # def create
  #     @user = User.new(params[:user])
  #   if @user.save
  #     flash[:success] = "ユーザー登録が完了しました！"
  #     log_in @user
  #     redirect_to @user
  #   else
  #     render 'new'
  #   end
  # end

  # def edit
  #   @user = User.find(params[:id])
  # end

  # def update
  #   @user = User.find(current_user.id)
  #   if @user.update!(user_params)
  #     flash.notice = "アカウントを更新しました"
  #     redirect_to user_path(current_user.id)
  #   else 
  #     flash.notice = "更新できませんでした"
  #     redirect_to edit_user_registration_path
  #   end
  # end

  # def destroy
  #     log_out if logged_in?
  #     redirect_to root_path
  # end
  
  def following
    @user  = User.find(params[:id])
    @users = @user.followings
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follower'
  end


  private
  def user_params
    params.require(:user).permit(:username, :email, :profile, :image)
  end

  def update_params
    params.require(:user).permit(:username, :email, :profile, :image)
  end

  # def private_user
  #   if current_user.email == 'guest@example.com'
  #     redirect_to missions_path, alert: 'ゲストユーザーはDMできません。'
  #   end
  # end

end