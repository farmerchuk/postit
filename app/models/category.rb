class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true, length: {minimum: 3}

  before_save :generate_slug!

  def generate_slug!
    self.slug = self.name.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-").gsub(/-+/, "-").downcase
  end

  def to_param
    self.slug
  end
end
