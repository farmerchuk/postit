class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: {minimum: 5}
  validates :password, presence: true, on: :create, length: {minimum: 8}

  sluggable_column :username

  def user_role
    self.role.to_sym
  end

  def admin?
    user_role == :admin
  end
end
