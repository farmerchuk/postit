class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable  # looks for foreign key in voteable columns, not votes_id

  validates :title, presence: true, length: {minimum: 2}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  before_save :generate_slug!

  def generate_slug!
    slug_url = self.title.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-").gsub(/-+/, "-").downcase
    slug_postfix = "-" << DateTime.now.to_s.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-").downcase[0,15]
    self.slug = slug_url << slug_postfix
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
