class FirmsController < ApplicationController
  before_filter :is_admin, except: [:show]

  def index
    redirect_to root_url
  end

  def show
    @firm = Firm.with_id_and_user(params[:id], params[:user_id]).first
    if @firm && (owner_or_admin?@firm.user_id)
      @user = @firm.user
    else
      redirect_to root_url, alert: 'Permission denied.'
    end
  end
  
  def new
    @user = User.find(params[:user_id])
    @firm = @user.firms.new
  end
  
  def create
    @user = User.find_by(id: params[:user_id])
    @firm = @user.firms.new(params[:firm].permit(:description,:license_count))
    if @firm.save
      redirect_to @user, notice: 'Firm was added'
    else
      flash.now.alert = "Firm wasn't created"
      render "new"
    end
  end
  
  def edit
    @firm = Firm.with_id_and_user(params[:id], params[:user_id]).first
    @user = @firm.user
  end
  
  def destroy
    @firm = Firm.with_id_and_user(params[:id], params[:user_id]).first
    @user = @firm.user
    @firm.destroy
    redirect_to @user, notice: 'Firm was deleted' 
  end

  def update
    @firm = Firm.with_id_and_user(params[:id], params[:user_id]).first
    if @firm && (admin?)
      @user = @firm.user
    else
      redirect_to root_url, alert: 'Permission denied.'
    end
    @firm.description = params[:firm][:description]
    if params[:firm][:license_count] == params[:firm][:license_count].to_i.to_s
      #This means if params[:firm][:license_count] is number
      @firm.license_count = params[:firm][:license_count].to_i
    else
      @firm.license_count = -1
    end
    if @firm.save
      redirect_to user_firm_path(@user,@firm), notice: 'Firm was updated'
    else
      #If params[:firm][:license_count] wasn't a number set it back
      #so that user will see what he entered
      @firm.license_count = params[:firm][:license_count].to_i
      flash.now.alert = "Firm wasn't updated"
      render "edit"
    end
  end
end
