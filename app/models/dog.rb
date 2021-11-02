class Dog < ApplicationRecord
  has_many_attached :images
  belongs_to :owner, optional: true, class_name: 'User', foreign_key: 'user_id'
  has_many :likes
  has_many :users_liked, through: :likes, source: :user
end