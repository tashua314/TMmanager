class User < ApplicationRecord
  attr_accessor :remember_token, :current_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable,:validatable

  # mount_uploader :image, ImageUploader
  before_save { self.email = email.downcase }
  validates :username,   presence: true, length: {maximum: 50}

  VALID_EMAIML_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                      length: { maximum: 255 },
                      format: { with: User::VALID_EMAIML_REGEX },
                      uniqueness: true
                      
  validates :password, presence: true, length: { minimum: 6 }
                      # has_secure_password
  validates :profile, length: { maximum: 200 } 


  has_many :missions, dependent: :destroy 
  has_many :messages, dependent: :destroy 
  has_many :likes, dependent: :destroy
  has_many :liked_missions, through: :likes, source: :mission
  
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  
  has_many :followings, through: :following_relationships, dependent: :destroy
  
  
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  
  has_many :followers, through: :follower_relationships, dependent: :destroy
  
  
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end
  
  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end
  
  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end
    
  
  def already_liked?(mission)
    self.likes.exists?(mission_id: mission.id)
  end

  # def already_commented?(mission)
  #   self.comments.exists?(mission_id: mission.id)
  # end 

  def create_notification_follow!(current_user)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

    def self.guest
      find_or_create_by!(email: 'guest@example.com') do |user|
        user.password = SecureRandom.urlsafe_base64
        # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

  has_many :comments, dependent: :destroy 
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  
end
