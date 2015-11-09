class Category < ActiveRecord::Base
  include SluggableJasonNov

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true, length: {minimum: 3}

  sluggable_column :name
end
