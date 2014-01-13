class AdminRoomController < ApplicationController

  def index
    @user = User.find(session[:user_id])
    if admin?
      @users = User.all
    end
  end
end
