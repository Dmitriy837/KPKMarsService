require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin = users(:admin)
    @user = users(:user)
  end

# Model validations-------------------------------------------
  test "should not save user without login" do
    u = User.new
    assert !u.save
  end
   
  test "should not save user with occupied login" do
    u = User.new(login: users(:user).login)
    assert !u.save
  end
  
  test "should not save user without password" do
    u = User.new(login: "name")
    assert !u.save
  end
# ------------------------------------------------------------
# Should have validations-------------------------------------
  test "should have firm if specified" do
    assert_not_nil users(:user).firms.first
  end  
# ------------------------------------------------------------
# Should recognize validations-------------------------------- 
  test 'should recognize users route' do
    assert_recognizes( { controller: "users", action: "index"}, users_path, extras={}, message=nil)
  end
  
  test 'should recognize new user route' do
    assert_recognizes( { controller: "users", action: "new"}, new_user_path, extras={}, message=nil)
  end

  test 'should recognize edit user route' do
    assert_recognizes( { controller: "users", action: "edit", id: users(:user).id.to_s }, edit_user_path(users(:user)), extras={}, message=nil)
  end

  test 'should recognize show user route' do
    assert_recognizes( { controller: "users", action: "show", id: users(:user).id.to_s }, user_path(users(:user)), extras={}, message=nil)
  end
    
  test 'should recognize create user route' do
    assert_recognizes( { controller:'users', action: 'create'}, { path: users_path, method: :post})
  end
  
  test 'should recognize destroy user route' do
    assert_recognizes( { controller: 'users', action: 'destroy', id: users(:user).id.to_s}, { path: user_path(users(:user)), method: :delete})
  end

  test 'should recognize update user route' do
    assert_recognizes( { controller: 'users', action: 'update', id: users(:user).id.to_s}, { path: user_path(users(:user)), method: :put})
  end
  
# ------------------------------------------------------------
# Should redirect validations---------------------------------       
  test 'index should redirect' do
    get :index
    assert_response :redirect
  end

  test "edit should redirect for wrong user" do
    get(:edit, { id: users(:admin).id.to_s }, { user_id: @user.id })
    assert_response :redirect
  end 
  
  test "new should redirect for user" do
    get(:new, nil, { user_id: @user.id })
    assert_response :redirect
  end

  test "show should redirect for wrong user" do
    get(:show, { id: users(:admin).id.to_s }, {user_id: users(:user).id})
    assert_response :redirect
  end 

  test "create should redirect for wrong user" do
    get(:create, { user: {login: "new_user", password: "111"} }, {user_id: users(:user).id})
    assert_response :redirect
  end 
  
  test "update should redirect for wrong user" do
    get(:update, { id: @admin.id.to_s, user: {login: "new_admin_login", password: "456"} }, {user_id: users(:user).id})
    assert_response :redirect
  end 
  
  test "destroy should redirect for wrong user" do
    get(:destroy, { id: @user.id }, {user_id: users(:user).id})
    assert_response :redirect
  end   

# ------------------------------------------------------------
# Should render validations-----------------------------------

  test "edit should render correct layout for admin" do
    get(:edit, { id: users(:user).id.to_s }, { user_id: users(:admin).id})
    assert_template layout: "layouts/application", partial: "_form"
  end

  test "edit should render correct layout for right user" do
    get(:edit, { id: users(:user).id.to_s }, { user_id: users(:user).id})
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test "new should render correct layout for admin" do
    get(:new, nil, {user_id: users(:admin).id})
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test "show should render correct layout for admin" do
    get(:show, { id: @user.id.to_s }, {user_id: @admin.id})
    assert_template :show, layout: "layouts/application"
  end
  
  test "show should render correct layout for right user" do
    get(:show, { id: @user.id.to_s }, {user_id: @user.id})
    assert_template :show, layout: "layouts/application"
  end
  
# ------------------------------------------------------------
# Should CUD for admin and right user-------------------------    
  test "should create user for admin" do
    assert_difference('User.count') do
      post :create, {user: {login: 'new_user', password: '111'} }, {user_id: @admin.id}
    end
    assert_not_nil User.find_by(login: 'new_user')
    assert_redirected_to users_path
    assert_equal 'User was added', flash[:notice]
  end
  
  test "should update user for admin" do
    assert_no_difference('User.count') do
      post :update, {user: {login: 'new_login', password: '123', old_password: '123'}, id: @user.id }, {user_id: @admin.id}
    end
    assert_not_nil User.find_by(login: 'new_login')
    assert_redirected_to root_url
    assert_equal 'User was updated', flash[:notice]
  end
 
  test "should delete user for admin" do
    assert_difference('User.count', -1) do
      post :destroy, { id: @user.id }, {user_id: @admin.id}
    end
    assert_nil User.find_by(id: @user.id)
    assert_redirected_to root_url
    assert_equal 'User was deleted', flash[:notice]
  end
  
  test "should update user for right user" do
    assert_no_difference('User.count') do
      post :update, {user: {login: 'new_login', password: '123', old_password: '111'}, id: @user.id }, {user_id: @user.id}
    end
    assert_not_nil User.find_by(login: 'new_login')
    assert_redirected_to root_url
    assert_equal 'User was updated', flash[:notice]
  end
  
  test "should not update user with right user, but wrong password" do
    assert_no_difference('User.count') do
      post :update, {user: {login: 'new_login', password: '123', old_password: '123'}, id: @user.id }, {user_id: @user.id}
    end
    assert_nil User.find_by(login: 'new_login')
    assert_equal 'Wrong password', flash[:alert]
  end
  
  test "should not update user for admin with wrong password" do
    assert_no_difference('User.count') do
      post :update, {user: {login: 'new_login', password: '123', old_password: '111'}, id: @user.id }, {user_id: @admin.id}
    end
    assert_nil User.find_by(login: 'new_login')
    assert_equal 'Wrong password', flash[:alert]
  end
# ------------------------------------------------------------
end
