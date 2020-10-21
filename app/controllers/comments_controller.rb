class CommentsController < ApplicationController
  before_action :authenticate_user!    
  # before_action :set_mission, only:[:create]

    def create
      @mission = Mission.find(params[:mission_id])
      @comment = @mission.comments.build(comment_params) 
      @comment.user_id = current_user.id
      @comment_mission = @comment.mission
      if @comment.save
        redirect_to controller: :missions, action: :show, id: @mission.id, notice:  'コメントしました'
        @comment_mission.create_notification_comment!(current_user, @comment_id)
      #   render :index
      # else
      #   flash[:aleft] = 'コメントできませんでした'
      #   redirect_back(fallback_location: root_path)
      end
    end
  

    def destroy
        Comment.find(params[:id]).destroy 
        redirect_to controller: :missions, action: :show, id:params[:mission_id], notice:'コメントを削除しました'
    end

  private
  # def set_mission
  #   if current_user.email == 'guest@example.com'
  #     redirect_to missions_path, alert: 'ゲストユーザーはコメントできません。'
  #   end
  # end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
