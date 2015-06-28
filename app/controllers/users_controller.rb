class UsersController < ActionController::Base
  before_filter :refresh_user
  respond_to :html, :json

  def show
    @user_id = params[:id]
    respond_with user
  end

  private

  def user
    @user ||= User.find_or_create_by(goodreads_id: params[:id])
  end

  def refresh_user
    if params[:refresh] || params[:reload] || (user.updated_at < 6.hours.ago)
      user.refresh!
    end
  end
end
