class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_filter :retrieve_user 
  helper_method :admin?
  helper_method :retrieve_firm
  
  def admin?
    session[:user_id] == 1
  end

  def owner_or_admin? user_id
    user_id == session[:user_id] || session[:user_id] == 1
  end
  
private

   def current_user
     @current_user ||= User.find(session[:user_id]) if session[:user_id]
   end

    def retrieve_user
       redirect_to log_in_path unless User.exists?(id: session[:user_id])
    end

    def is_admin
       redirect_to root_url, :alert => 'Permission denied.' unless session[:user_id] == 1
    end
    
    def retrieve_firm
      @firm = Firm.with_id_and_user(params[:firm_id], params[:user_id]).first
      unless @firm && (owner_or_admin?@firm.user.id)
        redirect_to root_url, alert: "Permission denied."
        return
      end
      @user = @firm.user
    end
end
