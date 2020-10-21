class MessagesController < ApplicationController
before_action :authenticate_user!, :only => [:create]


    def create
        if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
            @message = Message.new(message_params)
            @room=@message.room
            if @message.save
                @roommembernotme=Entry.where(:room_id => @room.id).where.not(:user_id => current_user.id)
                @theid=@roommembernotme.find_by(:room_id => @room.id)
                notification = current_user.active_notifications.new(
                    :room_id => @room.id,
                    :message_id => @message.id,
                    :visited_id => @theid.user_id,
                    :visiter_id => current_user.id,
                    :action => 'dm'
                )
                # 自分の投稿に対するコメントの場合は、通知済みとする
                if notification.visiter_id == notification.visited_id 
                    notification.checked = true
                end
                notification.save if notification.valid?     
                    redirect_to "/rooms/#{@message.room_id}"    
            else
                redirect_to"/rooms/#{@message.room_id}"
                flash[:alert] = 'コメントできませんでした'
            end
        else
            redirect_back(:fallback_location => missions_path)
        end
    end

    def edit
    end

    def update
        if @message.update(message_params)
            gets_entries_all_messages
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        if @comment.destroy
        redirect_to post_path(@post), :notice => 'コメントを削除しました'
    else
        flash.now[:alert] = 'コメント削除に失敗しました'
        render post_path(@post)
        end
    end


private
    def set_mission
        @mission = Mission.find(params[:mission_id])
    end

    def set_room
        @room = Room.find(params[:message][:room_id])
    end


    def set_message
        @message = Message.find(params[:id])
    end

    def gets_entries_all_messages
        @messages = @room.messages.includes(:user).order("created_at asc")
        @entries = @room.entries
    end

    def message_params
        params.require(:message).permit(:user_id, :body, :room_id, :visiter_id).merge(:user_id => current_user.id)
    end
end