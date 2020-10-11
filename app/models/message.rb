class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many   :notifications, dependent: :destroy
  validates  :body, length: { minimum: 1 }
end
