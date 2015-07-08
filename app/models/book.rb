class Book < ActiveRecord::Base
  has_many :user_books, dependent: :destroy
  has_many :users, through: :user_books
  validates :isbn, uniqueness: true, presence: true
  validates :title, presence: true

  def self.find_create_by_title_and_isbn title, isbn
    if book = Book.find_by(isbn: isbn)
      return book
    end

    book_data = Openlibrary::Data.find_by_isbn(isbn)
    if book_data && book_data.subjects
      genres = book_data.subjects.collect { |s| s['name'] }.to_json
    else
      genres = []
    end

    book = Book.new(
      isbn: isbn,
      title: title,
      genres:genres
    )

    book.save!

    book
  end

  def self.find_create_by_isbn isbn
    if book = Book.find_by(isbn: isbn)
      return book
    end

    book = goodreads.book_by_isbn(isbn)
    Book.create(isbn: isbn, title: book.title)
  end

  private

  def self.goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end
end
