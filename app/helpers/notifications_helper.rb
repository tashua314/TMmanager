module NotificationsHelper

    def notification_form(notification)
      @comment=nil
      visiter=link_to notification.visiter.name, notification.visiter, :style => "font-weight: bold;"
      your_mission=link_to 'あなたの投稿', notification.micropost, :style => "font-weight: bold;", :remote => true
      case notification.action
        when "follow" then
          "#{visiter}があなたをフォローしました"
        when "like" then
          "#{visiter}が#{your_mission}にいいね！しました"
        when "comment" then
          @comment=Comment.find_by(:id => notification.comment_id)&.content
          "#{visiter}が#{your_mission}にコメントしました"
        when "expire" then 
          "期限切れ"
      end
    end
    
      def unchecked_notifications
        @notifications = current_user.passive_notifications.where(:checked => false)
      end
end