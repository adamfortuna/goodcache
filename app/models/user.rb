class User < ActiveRecord::Base
  has_many :shelves, dependent: :destroy
  validates :goodreads_id, uniqueness: true

  after_create :refresh!

  def refresh!
    return true unless goodinfo
    update_attribute(:name, goodinfo['name'])
    goodinfo['user_shelves'].each do |shelf_info|
      if shelf = shelves.find_by(shelf: shelf_info['name'])
        shelf.refresh!
      else
        shelves.find_or_create_by(shelf: shelf_info['name'])
      end
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
