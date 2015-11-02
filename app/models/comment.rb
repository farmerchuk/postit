class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post
  has_many :votes, as: :voteable

  validates :body, presence: true

  before_save :generate_slug!

  def generate_slug!
    self.slug = DateTime.now.to_s.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-").downcase[0,15]
  end

  def to_param
    self.slug
  end

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end
end
