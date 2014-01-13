require 'test_helper'

class AdminRoomControllerTest < ActionController::TestCase

  def setup
    @admin = users(:admin)
    @user = users(:user)
  end

# Should recognize validations-------------------------------- 
  test 'should recognize admin room route' do
    assert_recognizes( { controller: "admin_room", action: "index"}, root_url, extras={}, message=nil)
  end
#-------------------------------------------------------------
# Should render validations-----------------------------------

  test "should render correct layout for admin" do
    get 'index', nil, { user_id: @admin.id}
    assert_response :success
    assert_template layout: "layouts/application", partial: "_mars_admin"
  end
  
  test "should render correct layout for user" do
    get 'index', nil, { user_id: @user.id}
    assert_response :success
    assert_template :index, layout: "layouts/application"
  end
#-------------------------------------------------------------  
  test 'should show greeting' do
    u = users(:user)
    session[:user_id] = u.id
    get 'index'
    assert_response :success
    assert_select 'h1', "Hello, #{u.login}!"
  end
end
