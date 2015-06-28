class User < ActiveRecord::Base
  has_many :shelves, dependent: :destroy
  validates :goodreads_id, uniqueness: true

  after_create :update_name

  private

  def update_name
    if result = goodreads.user(self.goodreads_id)
      update_attribute(:name, result['name'])
      result['user_shelves'].each do |shelf|
        shelves.find_or_create_by(shelf: shelf['name'])
      end
    end
  end

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end
end
