class RoomsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_guest, only: [:show]

  def index
    @rooms = current_user.rooms.includes(:messages).order("messages.created_at desc")
  end

  def create
    @room = Room.create
    Entry.create(:room_id => @room.id, :user_id => current_user.id)
    Entry.create(params.permit(:user_id, :room_id).merge(:room_id => @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @messages = @room.messages.all
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(:fallback_location => root_path)
    end
    
  end


  # def check_guest
  #   if  current_user.email == 'guest@example.com'
  #       redirect_to users_path, alert: 'ゲストユーザーはDMできません。'
  #   end
  # end

  private
    def entry_params
      params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id)
    end
end