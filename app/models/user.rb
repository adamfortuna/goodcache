class User < ActiveRecord::Base
  has_many :shelves, dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :books, through: :user_books
  validates :goodreads_id, uniqueness: true

  after_create :refresh!

  def refresh!
    return true unless goodinfo

    # Set the users name from Goodreads
    update_attribute(:name, goodinfo['name'])
    touch(:updated_at)

    # Create all their shelves with the number of books on each
    goodinfo['user_shelves'].each do |shelf_info|
      shelf = shelves.find_or_initialize_by(shelf: shelf_info['name'])
      shelf.books_count = shelf_info['book_count']
      shelf.save
    end
  end

  # Lookup a book from a specific users shelf by ISBN
  def book_by_isbn isbn
    book = Book.find_create_by_isbn isbn
    review = user_books.find_or_create_by(user: self, book: book)
    review.refresh! if review.needs_refresh?
    review.review
  end

  def book_by_goodreads_id goodreads_id
    book = Book.find_create_by_goodreads_id goodreads_id
    review = user_books.find_or_create_by(user: self, book: book)
    review.refresh! if review.needs_refresh?
    review.review
  end

  private

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end

  def goodinfo
    @goodinfo ||= goodreads.user(self.goodreads_id)
  end
end
