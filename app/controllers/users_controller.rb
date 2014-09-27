class UsersController < ActionController::Base
  respond_to :json

  # GET /users/13234.json
  def show
    user.refresh! if params[:refresh] || user.updated_at < 6.hours.ago
    render json: user.books
  end

  private

  def user
    @user ||= User.find_or_create_by_goodreads_id(params[:id])
  end
end
