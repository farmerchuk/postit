class Comment < ActiveRecord::Base
  belongs_to :user #:creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post
end
