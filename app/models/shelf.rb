class Shelf < ActiveRecord::Base
  belongs_to :user

  after_create :refresh!

  def refresh!
    self.books  = update_data
    self.save!
  end

  private

  def update_data
    goodreads.shelf(user.goodreads_id, shelf, { sort: 'date_read', order: 'd', per_page: 2000})['books']
  end

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end
end
