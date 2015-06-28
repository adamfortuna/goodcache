class User < ActiveRecord::Base
  has_many :shelves, dependent: :destroy
  validates :goodreads_id, uniqueness: true

  after_create :refresh!

  def refresh!
    return true unless goodinfo

    # Set the users name from Goodreads
    update_attribute(:name, goodinfo['name'])

    # Create all their shelves with the number of books on each
    goodinfo['user_shelves'].each do |shelf|
      shelves.find_or_create_by(shelf: shelf['name'], books_count: shelf['book_count'])
    end
  end

  private

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end

  def goodinfo
    @goodinfo ||= goodreads.user(self.goodreads_id)
  end
end
