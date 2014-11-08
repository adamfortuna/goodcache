class UserBooksController < ActionController::Base
  before_filter :refresh_shelf
  respond_to :json

  # GET /users/:user_id/books.json?shelf=read  
  #   force a reload with ?reload=true or ?refresh=true
  def index
    render json: user_shelf.books
  end

  # GET /users/:user_id/books/:id.json?shelf=read
  #   force a reload with ?reload=true or ?refresh=true
  def show
    render json: user_shelf.book_by_isbn(params[:id])
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
    user_shelf.refresh! if params[:refresh] || params[:reload]
  end
end
