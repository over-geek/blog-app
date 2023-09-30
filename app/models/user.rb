class User < ApplicationRecord
  has_many :posts, foreign_key: 'author_id', class_name: 'Post'
  has_many :comments, foreign_key: 'user_id', class_name: 'Comment'
  has_many :likes, foreign_key: 'user_id', class_name: 'Like'

  def recent_posts
    posts.order(created_at: :desc).limit(3)
  end
end
