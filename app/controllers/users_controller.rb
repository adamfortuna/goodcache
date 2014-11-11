class UsersController < ActionController::Base
  respond_to :html

  def show
    @user_id = params[:refresh]
  end
end
