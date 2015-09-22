class Shelf < ActiveRecord::Base
  belongs_to :user

  # Grab the latest data from Goodreads
  def refresh!
    update_attributes(
      books: update_data,
      books_count: update_data.length
    )
  end

  # Get genres for all books
  def annotate_books!
    update_attribute(:books, annotated_books)
  end

  def needs_refresh?
    books.nil? || (updated_at < 6.hours.ago)
  end

  private

  # Todo: Make this work with more than 200 books
  def update_data
    return @update_data if @update_data
    page = 1
    @update_data = []

    loop do
      result = goodreads.shelf(user.goodreads_id, shelf, { sort: 'date_read', order: 'd', per_page: 20, page: page })
      found_books = result['total']
      currently_processed_books = (page * 20)
      puts "Found #{found_books} books. Looking at page #{page}, total processed: #{currently_processed_books}"
      @update_data << result['books']
      break if currently_processed_books >= found_books
      page = page + 1
    end

    @update_data ||= @update_data.flatten
  end

  def method_name

  end

  def goodreads
    @client ||= Goodreads.new(api_key: APP_CONFIG['goodreads_key'], api_secret: APP_CONFIG['goodreads_secret'])
  end

  def annotated_books
    update_data.collect do |book|
      if book['book']['isbn'] && book['book']['title']
        b = Book.find_create_by_title_and_isbn(book['book']['title'], book['book']['isbn'])
        book['book']['genres'] = b.genres
      end
      book
    end
  end
end
