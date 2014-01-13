class DevicesController < ApplicationController
  before_filter :retrieve_device, only: [:show, :edit, :update, :destroy]
  before_filter :retrieve_firm, only: [:new, :create, :index]
  
  def new
    @device = @firm.devices.new 
  end

  def create
    @device = @firm.devices.new(params[:device].permit(:imei))
    if @firm.license_count > 0 && (owner_or_admin?@firm.user_id)
      @firm.transaction do
        begin
          dev = params[:device]
          if dev["last_date(1i)"] && dev["last_date(2i)"] && dev["last_date(3i)"]
            date = Date.new dev["last_date(1i)"].to_i, dev["last_date(2i)"].to_i, dev["last_date(3i)"].to_i
          else
            date = Date.today
          end
          @device.last_date = date.to_s.gsub("-",'').to_i
          @device.save!
          @firm.license_count -= 1
          @firm.save!
        rescue
         flash.now.alert = "Device wasn't added"
         render "new"   
         return       
        end
      end
      redirect_to user_firm_devices_path(@user, @firm), notice: 'Device was added'
    else
	  flash.now.alert = "Device wasn't added"
      render "new"
    end
  end
  
  def destroy
    @firm.transaction do
      begin
        @device.destroy!
        @firm.license_count += 1
        @firm.save!
      rescue
        redirect_to user_firm_devices_path, alert: "Device wasn't deleted"
      end
    end
    redirect_to user_firm_devices_path, notice: 'Device was deleted'
  end

  def update
    @device.imei = params[:device][:imei]
    if admin?
      dev = params[:device]
      begin
        date = Date.new dev["last_date(1i)"].to_i, dev["last_date(2i)"].to_i, dev["last_date(3i)"].to_i
      rescue Exception=>e
        flash.now.alert = e
        render "edit"
        return
      end
      @device.last_date = date.to_s.gsub("-",'').to_i
    end
    if @device.save
      redirect_to user_firm_device_path(@user, @firm, @device), notice: 'Device was updated'
      return
    else
      flash.now.alert = "Device wasn't updated"
      render "edit"
    end
  end

  def index
    @devices = @firm.devices
  end

  def show
  end

  def edit
  end
  
private
    def retrieve_device
      @device = Device.with_id_user_and_firm(params[:id],params[:user_id],params[:firm_id]).first
      unless @device && (owner_or_admin?@device.firm.user.id) then 
        redirect_to root_url, alert: "Permission denied." 
        return
      end
      @firm = @device.firm
      @user = @firm.user
    end
end
