require 'test_helper'

class FtpServersControllerTest < ActionController::TestCase

  def setup
    @ftp_server = ftp_servers(:server)
    @firm = @ftp_server.firm
    @user = @firm.user
    @admin = users(:admin)
  end
  
# Model validations-------------------------------------------
  test "should not save ftp-server without url" do
    s = FtpServer.new(port: 10, username: "user", firm_id: 1)
    assert !s.save
  end

  test "should not save ftp-server without port" do
    s = FtpServer.new(url: "192.168.1.1", username: "user", firm_id: 1)
    assert !s.save
  end

  test "should not save ftp-server with non-numeric port" do
    s = FtpServer.new(url: "192.168.1.1", port: "port", username: "user", firm_id: 1)
    assert !s.save
  end
 
  test "should not save ftp-server without username" do
    s = FtpServer.new(url: "192.168.1.1", port: 10, firm_id: 1)
    assert !s.save
  end
  
  test "should not save ftp-server without firm_id" do
    s = FtpServer.new(url: "192.168.1.1", port: 10, username: "user")
    assert !s.save
  end
  
  test "should not save ftp-server with non-numeric firm_id" do
    s = FtpServer.new(url: "192.168.1.1", port: 10, username: "user", firm_id: "firm")
    assert !s.save
  end  
  
  test "should save valid ftp-server" do
    s = FtpServer.new(url: "192.168.1.1", port: 10, username: "user", firm_id: 1)
    assert s.save
  end
#-------------------------------------------------------------
# Should recognize validations-------------------------------- 
  test 'should recognize ftp_servers route' do
    assert_recognizes( { controller: "ftp_servers", action: "index", user_id: @user.id.to_s, firm_id: @firm.id.to_s}, user_firm_ftp_servers_path(@user,@firm), extras={}, message=nil)
  end
  
  test 'should recognize new ftp_server route' do
    assert_recognizes( { controller: "ftp_servers", action: "new", user_id: @user.id.to_s, firm_id: @firm.id.to_s}, new_user_firm_ftp_server_path(@user,@firm), extras={}, message=nil)
  end

  test 'should recognize edit ftp_server route' do
    assert_recognizes( { controller: "ftp_servers", action: "edit", user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, edit_user_firm_ftp_server_path(@user,@firm,@ftp_server), extras={}, message=nil)
  end

  test 'should recognize show ftp_server route' do
    assert_recognizes( { controller: "ftp_servers", action: "show", user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, user_firm_ftp_server_path(@user,@firm,@ftp_server), extras={}, message=nil)
  end
    
  test 'should recognize create ftp_server route' do
    assert_recognizes( { controller: 'ftp_servers', action: 'create', user_id: @user.id.to_s, firm_id: @firm.id.to_s}, { path: user_firm_ftp_servers_path(@user,@firm), method: :post})
  end
  
  test 'should recognize destroy ftp_server route' do
    assert_recognizes( { controller: 'ftp_servers', action: 'destroy', user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s}, { path: user_firm_ftp_server_path(@user,@firm,@ftp_server), method: :delete})
  end

  test 'should recognize update ftp_server route' do
    assert_recognizes( { controller: 'ftp_servers', action: 'update', user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s}, { path: user_firm_ftp_server_path(@user,@firm,@ftp_server), method: :put})
  end
# ------------------------------------------------------------
# Should redirect validations---------------------------------       
  test 'index should redirect from ftp_servers for wrong user' do
    get :index, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end

  test 'show should redirect from for wrong user' do
    get :show, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end

  test "edit should redirect for wrong user" do
    get :edit, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 
  
  test "update should redirect for wrong user" do
    get :update, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 
  
  test "new should redirect for wrong user" do
    get :new, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end
  
  test "create should redirect for wrong user" do
    get :create, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end
  
  test 'destroy should redirect from for wrong user' do
    get :destroy, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 

# ------------------------------------------------------------
# Should render validations-----------------------------------

  test "edit should render correct layout for admin" do
    get :edit, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, { user_id: @admin.id}
    assert_template layout: "layouts/application", partial: "_form"
  end

  test "show should render correct layout for admin" do
    get(:show, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, { user_id: @admin.id})
    assert_template :show, layout: "layouts/application"
  end
  
  test "new should render correct layout for admin" do
    get(:new, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @admin.id})
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test "index should render correct layout for admin" do
    get(:index, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, { user_id: @admin.id})
    assert_template :index, layout: "layouts/application"
  end
  
  test "edit should render correct layout for right user" do
    get :edit, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, { user_id: @user.id}
    assert_template layout: "layouts/application", partial: "_form"
  end

  test "show should render correct layout for right user" do
    get(:show, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id.to_s }, { user_id: @user.id})
    assert_template :show, layout: "layouts/application"
  end
  
  test "new should render correct layout for right user" do
    get(:new, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id})
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test "index should render correct layout for right user" do
    get(:index, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, { user_id: @user.id})
    assert_template :index, layout: "layouts/application"
  end
# ------------------------------------------------------------
# Should CUD for admin and right user-------------------------    
  test "should create ftp_server for admin" do
    assert_difference('FtpServer.count') do
      post :create, {ftp_server: {url: 'new_url', port: '8080', username: 'username'}, user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil FtpServer.find_by(url: 'new_url')
    assert_redirected_to user_firm_ftp_servers_path @user, @firm
    assert_equal 'FTP-server was added', flash[:notice]
  end
  
  test "should update ftp_server for admin" do
    assert_no_difference('FtpServer.count') do
      post :update, {ftp_server: {url: 'new_url', port: '8080', username: 'username'}, id: @ftp_server.id.to_s, firm_id: @firm.id.to_s, user_id: @user.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil FtpServer.find_by(id: @ftp_server.id)
    assert_redirected_to user_firm_ftp_server_path(@user, @firm, @ftp_server)
    assert_equal 'FTP-server was updated', flash[:notice]
  end
 
  test "should delete ftp_server for admin" do
    assert_difference('FtpServer.count', -1) do
      post :destroy, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id }, {user_id: @admin.id}
    end
    assert_nil FtpServer.find_by(id: @ftp_server.id)
    assert_redirected_to user_firm_ftp_servers_path @user, @firm
    assert_equal 'FTP-server was deleted', flash[:notice]
  end
  
  test "should create ftp_server for right user" do
    assert_difference('FtpServer.count') do
      post :create, {ftp_server: {url: 'new_url', port: '8080', username: 'username'}, user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    end
    assert_not_nil FtpServer.find_by(url: 'new_url')
    assert_redirected_to user_firm_ftp_servers_path @user, @firm
    assert_equal 'FTP-server was added', flash[:notice]
  end
  
  test "should update ftp_server for right user" do
    assert_no_difference('FtpServer.count') do
      post :update, {ftp_server: {url: 'new_url', port: '8080', username: 'username'}, id: @ftp_server.id.to_s, firm_id: @firm.id.to_s, user_id: @user.id.to_s }, {user_id: @user.id}
    end
    assert_not_nil FtpServer.find_by(id: @ftp_server.id)
    assert_redirected_to user_firm_ftp_server_path(@user, @firm, @ftp_server)
    assert_equal 'FTP-server was updated', flash[:notice]
  end
 
  test "should delete ftp_server for right user" do
    assert_difference('FtpServer.count', -1) do
      post :destroy, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @ftp_server.id }, {user_id: @user.id}
    end
    assert_nil FtpServer.find_by(id: @ftp_server.id)
    assert_redirected_to user_firm_ftp_servers_path @user, @firm
    assert_equal 'FTP-server was deleted', flash[:notice]
  end
# ------------------------------------------------------------
end
