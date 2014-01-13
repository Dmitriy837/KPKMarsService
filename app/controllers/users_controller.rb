class UsersController < ApplicationController
  before_filter :is_admin, except: [:edit, :update, :show]
  before_filter :can_see, only: [:edit, :update, :show]
  def new
     @user = User.new
  end

  def index
    redirect_to root_url
  end

  def create
    @user = User.new(params[:user].permit(:login))
    @user.encrypt_password params[:user][:password]
    if @user.save
      redirect_to users_path, notice: 'User was added'
    else
 	  flash.now.alert = "User wasn't added"
      render "new"
    end
  end
  
  def show
  end

  def edit
  end
  
  def update
    if admin?
      @admin = User.find_by(id: session[:user_id])
      if BCrypt::Engine.hash_secret(params[:user][:old_password], @admin.password_salt) != @admin.password_hash
        flash.now.alert = "Wrong password"
        render "edit"
        return
      end
    else
      if @user.password_hash != BCrypt::Engine.hash_secret(params[:user][:old_password], @user.password_salt)
        flash.now.alert = "Wrong password"
        render "edit"
        return
      end
    end
    @user.login = params[:user][:login]
    @user.encrypt_password params[:user][:password]
    if @user.save
      redirect_to root_url, notice: 'User was updated'
    else
	  flash.now.alert = "User wasn't updated"
      render "edit"
    end
  end
  
  def destroy
     @user = User.find_by(id: params[:id])
     if @user
       @user.destroy
       redirect_to root_url, notice: "User was deleted"
     else
       redirect_to root_url, notice: "User wasn't deleted"
     end
     
  end
  
private    
     def can_see
        @user = User.find_by(id: params[:id])
        redirect_to root_url, alert: "Permissions denied" unless @user && (owner_or_admin?@user.id)
     end
end
