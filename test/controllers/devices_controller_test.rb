require 'test_helper'

class DevicesControllerTest < ActionController::TestCase

  def setup
    @device = devices(:device)
    @firm = @device.firm
    @user = @firm.user
    @admin = users(:admin)
  end

# Model validations-------------------------------------------
  test "should not save device without imei" do
    d = Device.new(firm_id: 1, last_date: 1104000)
    assert !d.save
  end
  
  test "should not save device without last_date" do
    d = Device.new(firm_id: 1, imei: "arsgvrfw4tw34tv34t")
    assert !d.save
  end
  
  test "should not save device with non-numeric last_date" do
    d = Device.new(firm_id: 1, imei: "ertv3sfvestvt", last_date: "date")
    assert !d.save
  end
  
  test "should not save device with non-numeric firm_id" do
    d = Device.new(firm_id: "firm", imei: "ertv3sfvestvt", last_date: 3053426)
    assert !d.save
  end
  
  test "should not save device with non-integer last_date" do
    d = Device.new(firm_id: 1, imei: "ertv3sfvestvt", last_date: 345326.36)
    assert !d.save
  end
  
  test "should not save device with non-integer firm_id" do
    d = Device.new(firm_id: 1.1, imei: "ertv3sfvestvt", last_date: 345326)
    assert !d.save
  end

  test "should save valid device" do
    d = Device.new(firm_id: 1, imei: "ertv3sfvestvt", last_date: 345326)
    assert d.save
  end
#-------------------------------------------------------------
# Should recognize validations-------------------------------- 
  test 'should recognize devices route' do
    assert_recognizes( { controller: "devices", action: "index", user_id: @user.id.to_s, firm_id: @firm.id.to_s}, user_firm_devices_path(@user,@firm), extras={}, message=nil)
  end
  
  test 'should recognize new device route' do
    assert_recognizes( { controller: "devices", action: "new", user_id: @user.id.to_s, firm_id: @firm.id.to_s}, new_user_firm_device_path(@user,@firm), extras={}, message=nil)
  end

  test 'should recognize edit device route' do
    assert_recognizes( { controller: "devices", action: "edit", user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, edit_user_firm_device_path(@user,@firm,@device), extras={}, message=nil)
  end

  test 'should recognize show device route' do
    assert_recognizes( { controller: "devices", action: "show", user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, user_firm_device_path(@user,@firm,@device), extras={}, message=nil)
  end
    
  test 'should recognize create device route' do
    assert_recognizes( { controller: 'devices', action: 'create', user_id: @user.id.to_s, firm_id: @firm.id.to_s}, { path: user_firm_devices_path(@user,@firm), method: :post})
  end
  
  test 'should recognize destroy device route' do
    assert_recognizes( { controller: 'devices', action: 'destroy', user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s}, { path: user_firm_device_path(@user,@firm,@device), method: :delete})
  end

  test 'should recognize update device route' do
    assert_recognizes( { controller: 'devices', action: 'update', user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s}, { path: user_firm_device_path(@user,@firm,@device), method: :put})
  end
# ------------------------------------------------------------
# Should redirect validations---------------------------------       
  test 'index should redirect from devices for wrong user' do
    get :index, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end

  test 'show should redirect from device for wrong user' do
    get :show, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end

  test "edit should redirect for wrong user" do
    get :edit, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 
  
  test "update should redirect for wrong user" do
    get :update, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, {user_id: @user.id}
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
    get :destroy, { user_id: @admin.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 

# ------------------------------------------------------------
# Should render validations-----------------------------------

  test "edit should render correct layout for admin" do
    get :edit, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, { user_id: @admin.id}
    assert_response :success
    assert_template layout: "layouts/application", partial: "_form"
  end

  test "show should render correct layout for admin" do
    get(:show, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, { user_id: @admin.id})
    assert_response :success
    assert_template :show, layout: "layouts/application"
  end
  
  test "new should render correct layout for admin" do
    get(:new, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @admin.id})
    assert_response :success
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test "index should render correct layout for admin" do
    get(:index, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, { user_id: @admin.id})
    assert_response :success
    assert_template :index, layout: "layouts/application"
  end
  
  test "edit should render correct layout for right user" do
    get :edit, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, { user_id: @user.id}
    assert_response :success
    assert_template layout: "layouts/application", partial: "_form"
  end

  test "show should render correct layout for right user" do
    get(:show, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id.to_s }, { user_id: @user.id})
    assert_response :success
    assert_template :show, layout: "layouts/application"
  end
  
  test "new should render correct layout for right user" do
    get(:new, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id})
    assert_response :success
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test "index should render correct layout for right user" do
    get(:index, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, { user_id: @user.id})
    assert_response :success
    assert_template :index, layout: "layouts/application"
  end
# ------------------------------------------------------------
# Should CUD for admin and right user-------------------------    
  test "should create device for admin" do
    assert_difference('Device.count') do
      post :create, {device: {imei: 'new_imei', last_date: 40000101}, user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil Device.find_by(imei: 'new_imei')
    assert_redirected_to user_firm_devices_path @user, @firm
    assert_equal 'Device was added', flash[:notice]
  end
  
  test "should update device for admin" do
    assert_no_difference('Device.count') do
      post :update, {device: {imei: 'new_imei', "last_date(1i)" => "4000", "last_date(2i)" => "01", "last_date(3i)" => "01"}, id: @device.id.to_s, firm_id: @firm.id.to_s, user_id: @user.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil Device.find_by(id: @device.id)
    assert_redirected_to user_firm_device_path(@user, @firm, @device)
    assert_equal 'Device was updated', flash[:notice]
  end
 
  test "should delete device for admin" do
    assert_difference('Device.count', -1) do
      post :destroy, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id }, {user_id: @admin.id}
    end
    assert_nil Device.find_by(id: @device.id)
    assert_redirected_to user_firm_devices_path @user, @firm
    assert_equal 'Device was deleted', flash[:notice]
  end
  
  test "should create device for right user" do
    assert_difference('Device.count') do
      post :create, {device: {imei: 'new_imei', last_date: 40000101}, user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    end
    assert_not_nil Device.find_by(imei: 'new_imei')
    assert_redirected_to user_firm_devices_path @user, @firm
    assert_equal 'Device was added', flash[:notice]
  end
  
  test "should update device for right user" do
    assert_no_difference('Device.count') do
      post :update, {device: {imei: 'new_imei', last_date: 40000101}, id: @device.id.to_s, firm_id: @firm.id.to_s, user_id: @user.id.to_s }, {user_id: @user.id}
    end
    assert_not_nil Device.find_by(id: @device.id)
    assert_redirected_to user_firm_device_path(@user, @firm, @device)
    assert_equal 'Device was updated', flash[:notice]
  end
 
  test "should delete device for right user" do
    assert_difference('Device.count', -1) do
      post :destroy, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @device.id }, {user_id: @user.id}
    end
    assert_nil Device.find_by(id: @device.id)
    assert_redirected_to user_firm_devices_path @user, @firm
    assert_equal 'Device was deleted', flash[:notice]
  end
# ------------------------------------------------------------
end
