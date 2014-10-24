class UsersController < ActionController::Base
  respond_to :json

  # GET /users/13234.json?shelf=read
  # Shelves: read, currently-reading, to-read
  def show
    user_shelf.refresh! if params[:refresh] || params[:reload]
    render json: user_shelf.books
  end

  private

  def user
    @user ||= User.find_or_create_by_goodreads_id(params[:id])
  end

  def shelf
    params[:shelf] || 'read'
  end

  def user_shelf
    @user_shelf ||= user.shelf_for(shelf)
  end
end
