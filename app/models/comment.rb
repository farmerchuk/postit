class Comment < ActiveRecord::Base
  include VoteableJasonNov

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post

  validates :body, presence: true
end
