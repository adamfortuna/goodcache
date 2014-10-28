class UserBooksController < ActionController::Base
  before_filter :refresh_shelf
  respond_to :json

  # GET /users/:user_id/books.json?shelf=read  
  def index
    render json: user_shelf.books
  end

  # GET /users/:user_id/books/:id.json?shelf=read
  def show
    render json: filtered_books(user_shelf.books).first
  end

  private

  def user
    @user ||= User.find_or_create_by_goodreads_id(params[:user_id])
  end

  # Shelves: read, currently-reading, to-read
  def shelf
    params[:shelf] || 'read'
  end

  def user_shelf
    @user_shelf ||= user.shelf_for(shelf)
  end

  def refresh_shelf
    user_shelf.refresh! if params[:refresh] || params[:reload]
  end

  def filtered_books books
    books.select do |book|
      book['book']['isbn'] == params[:id]
    end
  end
end
