class ParametersController < ApplicationController
  before_filter :is_admin
  before_filter :retrieve_parameter, only: [:show, :update, :edit, :destroy]
  before_filter :retrieve_firm, only: [:new, :create, :index]
  
  def new 
    @parameter = @firm.parameters.new
   end

  def create
    @parameter = @firm.parameters.new(params[:parameter].permit(:param_name,:param_value))
    if @parameter.save
      redirect_to user_firm_parameters_path(@user, @firm), notice: 'Parameter was added'
    else
      flash.now.alert = "Parameter wasn't created"
      render "new"
    end
  end
  
  def destroy
    if @parameter.destroy
      redirect_to user_firm_parameters_path(@user, @firm), notice: 'Parameter was deleted'
    else
      redirect_to root_url, notice: 'Parameter was not deleted'
    end
  end

  def update
    @parameter.update_attributes(params.require(:parameter).permit(:param_name,:param_value))
    if @parameter.save
      redirect_to user_firm_parameter_path(@user, @firm, @parameter), notice: 'Parameter was updated'
    else
      flash.now.alert = "Parameter wasn't updated"
      render "edit"
    end
  end

  def index
    @parameters = @firm.parameters
  end

  def show
  end

  def edit
  end
  
private
    def retrieve_parameter
      @parameter = Parameter.with_id_user_and_firm(params[:id],params[:user_id],params[:firm_id]).first
      redirect_to root_url, alert: "Can't find parameter." unless @parameter
      @firm = @parameter.firm
      @user = @firm.user
    end
end
