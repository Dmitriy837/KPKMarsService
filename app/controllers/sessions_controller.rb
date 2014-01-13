class SessionsController < ApplicationController
  skip_before_filter :retrieve_user
  
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
      return
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to log_in_path, notice: "Logged out!"
  end
end
