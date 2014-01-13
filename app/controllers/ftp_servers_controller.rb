class FtpServersController < ApplicationController
  before_filter :retrieve_ftp_server, only: [:show, :edit, :update, :destroy]
  before_filter :retrieve_firm, only: [:new, :create, :index]
  
  def new 
    @ftp_server = @firm.ftp_servers.new
  end

  def create
    @ftp_server = @firm.ftp_servers.new(params[:ftp_server].permit(:url,:port,:username,:password))
    if @ftp_server.save
      redirect_to user_firm_ftp_servers_path(@user, @firm), notice: 'FTP-server was added'
    else
      flash.now.alert = "FTP-server wasn't added"
      render "new"
    end
  end
  
  def destroy
    if @ftp_server.destroy
      redirect_to user_firm_ftp_servers_path(@user, @firm), notice: 'FTP-server was deleted'
    else
      redirect_to user_firm_ftp_servers_path, alert: "FTP-server wasn't deleted"
    end
  end

  def update
    @ftp_server.update_attributes(params.require(:ftp_server).permit(:url,:port,:username,:password))
    if @ftp_server.save
      redirect_to user_firm_ftp_server_path(@user, @firm, @ftp_server), notice: 'FTP-server was updated'
    else
      flash.now.alert = "FTP-server wasn't updated"
      render "edit"
    end
  end

  def index
    @ftp_servers = @firm.ftp_servers
  end

  def show
  end

  def edit
  end
  
private
    def retrieve_ftp_server
      @ftp_server = FtpServer.with_id_user_and_firm(params[:id],params[:user_id],params[:firm_id]).first
      unless @ftp_server && (owner_or_admin?@ftp_server.firm.user.id) then 
        redirect_to root_url, alert: "Permission denied." 
        return
      end
      @firm = @ftp_server.firm
      @user = @firm.user
    end
end
