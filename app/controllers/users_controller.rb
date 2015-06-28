class UsersController < ActionController::Base
  respond_to :html, :json

  def show
    @user_id = params[:id]

    respond_with user
  end

  private

  def user
    @user ||= User.find_or_create_by(goodreads_id: params[:id])
  end
end
