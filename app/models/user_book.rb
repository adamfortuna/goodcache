class UserBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :user_id, presence: true
  validates :book_id, presence: true

  after_create :refresh!


  def remote_review
    goodreads.shelf(user.goodreads_id, 'read', { 'search[query]' =>  book.title })['books'].first
  end

  def refresh!
    self.review = remote_review
    self.save
    self.touch(:updated_at)
  end

  def needs_refresh?
    review.nil? || (updated_at < 6.hours.ago)
  end

  private

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end
end
