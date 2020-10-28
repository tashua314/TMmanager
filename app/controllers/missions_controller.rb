class MissionsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_guest, only: :new
  
    def index
      if params[:search] == nil
        @missions = Mission.all
        elsif params[:search] == ''
          @missions = Mission.all
        else
          #部分検索
        @missions = Mission.where("content LIKE ? ",'%' + params[:search] + '%')
      end 
          user = current_user
          mission = user.missions
          mission.each do |m|
            if  Time.now > m.deadline
              m.create_notification_deadline!(m)
            end
          end
    end

    def new 
      @mission = Mission.new
    end

    def create
      @mission = Mission.new(mission_params)

      @mission.user_id = current_user.id

      if @mission.save
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
      end
    end
    
    def show
      @mission = Mission.find(params[:id])
      @like = Like.new
      @user = User.find_by(:id => @mission.user_id)
      @comments = Comment.where(:mission_id => params[:id])
      @comment = @mission.comments.build

    end

    def edit
      @mission = Mission.find(params[:id])
      if @mission.user == current_user
        render "edit"
      else 
        redirect_to missions_path
      end
    end

    def update
      @mission = Mission.find(params[:id])
      if @mission.update(mission_params)
        redirect_to :action => "show", :id => @mission.id
      else
        redirect_to :action => "new"
      end
    end

    def destroy
      Mission.find(params[:id]).destroy
      redirect_to :action => :index
    end

    def done 
      @mission = Mission.find(params[:id])
      if @mission.completed == 0
        @mission.update(completed:1)
        redirect_to :action => :index
      end
    end

    # def check_guest
    #   if  current_user.email == 'guest@example.com'
    #       redirect_to missions_path, alert: 'ゲストユーザーは投稿できません。'
    #   end
    # end
    
    private
    def mission_params
      params.require(:mission).permit(:content, :penalty, :image, :deadline, :completed, :user_id)
    end


  end