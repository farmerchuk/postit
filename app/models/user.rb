class User < ActiveRecord::Base
  include SluggableJasonNov

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: {minimum: 5}
  validates :password, presence: true, on: :create, length: {minimum: 8}
  validates :phone_number, presence: true, numericality: {only_integer: true},
    length: {minimum: 10, maximum: 10}

  sluggable_column :username

  def user_role
    self.role.to_sym
  end

  def admin?
    user_role == :admin
  end

  def two_factor_enabled?
    self.two_factor
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6))
  end

  def send_pin_to_twilio
    account_sid = 'SECRET_ACCOUNT'
    auth_token = 'SECRET_TOKEN'

    # set up a client to talk to the Twilio REST API
    client = Twilio::REST::Client.new account_sid, auth_token

    client.account.messages.create({
    	:from => '+15555555555',
    	:to => "+1#{self.phone_number}",
    	:body => "#{self.pin}",
    })
  end
end
