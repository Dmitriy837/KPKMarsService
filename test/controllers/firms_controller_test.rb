require 'test_helper'

class FirmsControllerTest < ActionController::TestCase

  def setup
    @firm = firms(:firm)
    @user = @firm.user
    @admin = users(:admin)
  end

# Model validations-------------------------------------------
  test "should not save firm without description" do
    f = Firm.new(user_id: 1, license_count: 100)
    assert !f.save
  end

  test "should not save firm without license_count" do
    f = Firm.new(user_id: 1,description: "firm")
    assert !f.save
  end
  
  test "should not save firm with negative license_count" do
    f = Firm.new(user_id: 1,description: "firm",license_count: -3)
    assert !f.save
  end
  
  test "should not save firm with non-numeric license_count" do
    f = Firm.new(user_id: 1, description: "firm", license_count: "count")
    assert !f.save
  end
  
  test "should not save firm with non-numeric user_id" do
    f = Firm.new(user_id: "user", description: "firm", license_count: 2)
    assert !f.save
  end

  test "should not save firm with non-integer user_id" do
    f = Firm.new(user_id: 1.5, description: "firm", license_count: 2)
    assert !f.save
  end

  test "should not save firm with non-integer license_count" do
    f = Firm.new( user_id: "user", description: "firm", license_count: 2.2)
    assert !f.save
  end

  test "should save valid firm" do
    f = Firm.new(description: "new_firm", license_count: 34, user_id: 1)
    assert f.save
  end
# ------------------------------------------------------------
# Should have validations-------------------------------------
  test "should have parameters if specified" do
    assert_not_nil firms(:firm).parameters.first
  end  

  test "should have ftp_servers if specified" do
    assert_not_nil firms(:firm).ftp_servers.first
  end  

  test "should have devices if specified" do
    assert_not_nil firms(:firm).devices.first
  end  
# ------------------------------------------------------------
# Should recognize validations-------------------------------- 
  test 'should recognize firms route' do
    assert_recognizes( { controller: "firms", action: "index", user_id: @user.id.to_s}, user_firms_path(@user), extras={}, message=nil)
  end
  
  test 'should recognize new firm route' do
    assert_recognizes( { controller: "firms", action: "new", user_id: @user.id.to_s}, new_user_firm_path(@user), extras={}, message=nil)
  end

  test 'should recognize edit firm route' do
    assert_recognizes( { controller: "firms", action: "edit", user_id: @user.id.to_s, id: @firm.id.to_s }, edit_user_firm_path(@user,@firm), extras={}, message=nil)
  end

  test 'should recognize show firm route' do
    assert_recognizes( { controller: "firms", action: "show", user_id: @user.id.to_s, id: @firm.id.to_s }, user_firm_path(@user,@firm), extras={}, message=nil)
  end
    
  test 'should recognize create firm route' do
    assert_recognizes( { controller: 'firms', action: 'create', user_id: @user.id.to_s}, { path: user_firms_path(@user), method: :post})
  end
  
  test 'should recognize destroy firm route' do
    assert_recognizes( { controller: 'firms', action: 'destroy', user_id: @user.id.to_s, id: @firm.id.to_s}, { path: user_firm_path(@user,@firm), method: :delete})
  end

  test 'should recognize update firm route' do
    assert_recognizes( { controller: 'firms', action: 'update', user_id: @user.id.to_s, id: @firm.id.to_s}, { path: user_firm_path(@user,@firm), method: :put})
  end
# ------------------------------------------------------------
# Should redirect validations---------------------------------       
  test 'should redirect from firms for user' do
    get :index, { user_id: @user.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end

  test "edit should redirect for user" do
    get :edit, { user_id: @user.id.to_s, id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 
  
  test "update should redirect for user" do
    get :update, { user_id: @user.id.to_s, id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 
  
  test "new should redirect for user" do
    get :new, { user_id: @user.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end
  
  test "create should redirect for user" do
    get :create, { user_id: @user.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end
  
  test 'destroy should redirect for user' do
    get :destroy, { user_id: @user.id.to_s, id: @firm.id.to_s}, {user_id: @user.id}
    assert_response :redirect
  end 

  test "index should redirect for admin" do
    get(:index, { user_id: @user.id.to_s }, { user_id: users(:admin).id})
    assert_response :redirect
  end
  
  test 'show should redirect firm for wrong user' do
    get :show, { user_id: @admin.id.to_s, id: @admin.firms.first.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end
# ------------------------------------------------------------
# Should render validations-----------------------------------

  test "edit should render correct layout for admin" do
    get :edit, { user_id: @user.id.to_s, id: @firm.id.to_s }, { user_id: users(:admin).id}
    assert_template layout: "layouts/application", partial: "_form"
  end

  test "show should render correct layout for admin" do
    get(:show, { user_id: @user.id.to_s, id: @firm.id.to_s }, { user_id: users(:admin).id})
    assert_template :show, layout: "layouts/application"
  end
  
  test "new should render correct layout for admin" do
    get(:new, { user_id: @user.id.to_s }, {user_id: users(:admin).id})
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test 'should show firm for right user' do
    get :show, { user_id: @user.id.to_s, id: @firm.id.to_s }, {user_id: @user.id}
    assert_template :show
  end
# ------------------------------------------------------------
# Should CUD for admin ---------------------------------------    
  test "should create firm for admin" do
    assert_difference('Firm.count') do
      post :create, {firm: {description: 'new_firm', license_count: 1}, user_id: @user.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil Firm.find_by(description: 'new_firm')
    assert_redirected_to @user
    assert_equal 'Firm was added', flash[:notice]
  end
  
  test "should update firm for admin" do
    assert_no_difference('Firm.count') do
      post :update, {firm: {description: 'new_firm', license_count: "1", user_id: @user.id.to_s}, id: @firm.id.to_s, user_id: @user.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil User.find_by(id: @firm.id)
    assert_redirected_to [@user,@firm]
    assert_equal 'Firm was updated', flash[:notice]
  end
 
  test "should delete firm for admin" do
    assert_difference('Firm.count', -1) do
      post :destroy, { id: @firm.id, user_id: @user.id.to_s }, {user_id: @admin.id}
    end
    assert_nil Firm.find_by(id: @firm.id)
    assert_redirected_to @user
    assert_equal 'Firm was deleted', flash[:notice]
  end
# ------------------------------------------------------------
end
