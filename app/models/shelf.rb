class Shelf < ActiveRecord::Base
  belongs_to :user

  after_create :refresh!

  before_save :create_books, if: :books_changed?

  def refresh!
    self.books  = update_data
    self.save!
  end

  private

  def update_data
    goodreads.shelf(user.goodreads_id, shelf, { sort: 'date_read', order: 'd', per_page: 200})['books']
  end

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end

  def create_books
    self.books.each do |book|
      b = Book.find_create_by_isbn(book['book']['title'], book['book']['isbn'])

      book['book']['genres'] = b.genres
    end
  end
end
