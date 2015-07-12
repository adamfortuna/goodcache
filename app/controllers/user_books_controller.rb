class UserBooksController < ActionController::Base
  before_filter :refresh_shelf
  respond_to :json

  # GET /users/:user_id/books.json?shelf=read
  #   force a reload with ?reload=true or ?refresh=true
  def index
    render json: user_shelf.books
  end

  # GET /users/:user_id/books/:id.json
  #   force a reload with ?reload=true or ?refresh=true
  def show
    render json: book
  end

  private

  def user
    @user ||= User.find_or_create_by(goodreads_id: params[:user_id])
  end

  # Shelves: read, currently-reading, to-read
  def shelf
    params[:shelf] || 'read'
  end

  def user_shelf
    @user_shelf ||= user.shelves.find_or_create_by(shelf: shelf)
  end

  def refresh_shelf
    user_shelf.refresh! if params[:refresh] || params[:reload] || user_shelf.needs_refresh?
  end

  def book
    if params[:id] =~ /^id-/
      user.book_by_goodreads_id(params[:id].split('-').last)
    else
      user.book_by_isbn(params[:id])
    end
  end
end
