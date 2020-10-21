class NotificationsController < ApplicationController
    def index
      @notifications = current_user.passive_notifications.page(params[:page]).per(20)
      # @notifications.where(checked: false).each do |notification|
      # notification.update_attributes(checked: true)
    #   @user=User.find(params[:user_id])
    # @currentUserEntry=Entry.where(user_id: current_user.id)
    # @userEntry=Entry.where(user_id: @user.id)
    # if @user.id == current_user.id
    #   @msg ="他のユーザーとDMしてみよう！"
    # else
    #   @currentUserEntry.each do |cu|
    #     @userEntry.each do |u|
    #       if cu.room_id == u.room_id then
    #         @isRoom = true
    #         @roomId = cu.room_id
    #       end
    #     end
    #   end
    # end

    def update
      notification=Notification.find(params[:id]) 
      if notification.update(:checked => true) 
        redirect_to :action => :index
      end
    end

    def destroy_all
        @notifications = current_user.passive_notifications.destroy_all
        redirect_to users_notifications_path
    end
  end
end
