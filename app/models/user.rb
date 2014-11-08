class User < ActiveRecord::Base
  has_many :shelves, dependent: :destroy
  validates :goodreads_id, uniqueness: true
end
