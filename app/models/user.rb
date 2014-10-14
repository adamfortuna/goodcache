class User < ActiveRecord::Base
  has_many :shelves

  def self.find_or_create_by_goodreads_id goodreads_id
    user = User.find_by(goodreads_id: goodreads_id) || create_user(goodreads_id)
  end

  def self.create_user(goodreads_id)
    User.create(goodreads_id: goodreads_id)
  end

  def shelf_for shelf_name
    shelf = shelves.find_or_create_by(shelf: shelf_name)
    return shelf if shelf.updated_at > 6.hours.ago

    shelf.refresh!
    shelf
  end
end
