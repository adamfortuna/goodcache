class UsersController < ActionController::Base
  respond_to :json

  # GET /users/13234.json?shelf=read
  # Shelves: read, currently-reading, to-read
  def show
    render json: user.shelf_for(shelf).books
  end

  private

  def user
    @user ||= User.find_or_create_by_goodreads_id(params[:id])
  end

  def shelf
    params[:shelf] || 'read'
  end
end
