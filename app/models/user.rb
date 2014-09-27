class User < ActiveRecord::Base
  after_create :refresh!

  def refresh!
    self.books = goodreads.shelf(goodreads_id, 'read', { sort: 'date_read', order: 'd', per_page: 2000})
    self.save!
  end

  def self.find_or_create_by_goodreads_id goodreads_id
    user = User.find_by(goodreads_id: goodreads_id) || create_user(goodreads_id)
  end

  def self.create_user(goodreads_id)
    User.create(goodreads_id: goodreads_id)
  end

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['key'], api_secret: APP_CONFIG['secret'])
  end
end
