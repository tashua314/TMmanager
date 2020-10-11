class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :mission
  validates  :comment, length: { minimum: 1 }      
end
