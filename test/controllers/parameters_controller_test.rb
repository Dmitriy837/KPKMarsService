require 'test_helper'

class ParametersControllerTest < ActionController::TestCase

  def setup
    @parameter = parameters(:param)
    @firm = @parameter.firm
    @user = @firm.user
    @admin = users(:admin)
  end

# Model validations-------------------------------------------
  test "should not save parameter without name and value" do
    p = Parameter.new
    assert !p.save
  end

  test "should not save parameter without name" do
    p = Parameter.new(param_value: "value")
    assert !p.save
  end
  
  test "should not save parameter without value" do
    p = Parameter.new(param_name: 'name')
    assert !p.save
  end
# ------------------------------------------------------------
# Should recognize validations-------------------------------- 
  test 'should recognize parameters route' do
    assert_recognizes( { controller: "parameters", action: "index", user_id: @user.id.to_s, firm_id: @firm.id.to_s}, user_firm_parameters_path(@user,@firm), extras={}, message=nil)
  end
  
  test 'should recognize new parameter route' do
    assert_recognizes( { controller: "parameters", action: "new", user_id: @user.id.to_s, firm_id: @firm.id.to_s}, new_user_firm_parameter_path(@user,@firm), extras={}, message=nil)
  end

  test 'should recognize edit parameter route' do
    assert_recognizes( { controller: "parameters", action: "edit", user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, edit_user_firm_parameter_path(@user,@firm,@parameter), extras={}, message=nil)
  end

  test 'should recognize show parameter route' do
    assert_recognizes( { controller: "parameters", action: "show", user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, user_firm_parameter_path(@user,@firm,@parameter), extras={}, message=nil)
  end
    
  test 'should recognize create parameter route' do
    assert_recognizes( { controller:'parameters', action: 'create', user_id: @user.id.to_s, firm_id: @firm.id.to_s}, { path: user_firm_parameters_path(@user,@firm), method: :post})
  end
  
  test 'should recognize destroy parameter route' do
    assert_recognizes( { controller: 'parameters', action: 'destroy', user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s}, { path: user_firm_parameter_path(@user,@firm,@parameter), method: :delete})
  end

  test 'should recognize update parameter route' do
    assert_recognizes( { controller: 'parameters', action: 'update', user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s}, { path: user_firm_parameter_path(@user,@firm,@parameter), method: :put})
  end
# ------------------------------------------------------------
# Should redirect validations---------------------------------       
  test 'should redirect from parameters for user' do
    get :index, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end

  test 'should redirect from parameter for user' do
    get :show, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end

  test "edit should redirect for user" do
    get :edit, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 
  
  test "update should redirect for user" do
    get :update, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 
  
  test "new should redirect for user" do
    get :new, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end
  
  test "create should redirect for user" do
    get :create, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end
  
  test 'should redirect from destroy parameter for user' do
    get :destroy, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, {user_id: @user.id}
    assert_response :redirect
  end 

# ------------------------------------------------------------
# Should render validations-----------------------------------

  test "edit should render correct layout for admin" do
    get :edit, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, { user_id: users(:admin).id}
    assert_template layout: "layouts/application", partial: "_form"
  end

  test "show should render correct layout for admin" do
    get(:show, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id.to_s }, { user_id: users(:admin).id})
    assert_template :show, layout: "layouts/application"
  end
  
  test "new should render correct layout for admin" do
    get(:new, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: users(:admin).id})
    assert_template layout: "layouts/application", partial: "_form"
  end
  
  test "index should render correct layout for admin" do
    get(:index, { user_id: @user.id.to_s, firm_id: @firm.id.to_s }, { user_id: users(:admin).id})
    assert_template :index, layout: "layouts/application"
  end
# ------------------------------------------------------------
# Should CUD for admin-------------------------    
  test "should create parameter for admin" do
    assert_difference('Parameter.count') do
      post :create, {parameter: {param_name: 'new_param', param_value: 'new_value'}, user_id: @user.id.to_s, firm_id: @firm.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil Parameter.find_by(param_name: 'new_param')
    assert_redirected_to user_firm_parameters_path @user, @firm
    assert_equal 'Parameter was added', flash[:notice]
  end
  
  test "should update parameter for admin" do
    assert_no_difference('Parameter.count') do
      post :update, {parameter: {param_name: 'new_param', param_value: 'new_value'}, id: @parameter.id.to_s, firm_id: @firm.id.to_s, user_id: @user.id.to_s }, {user_id: @admin.id}
    end
    assert_not_nil Parameter.find_by(id: @parameter.id)
    assert_redirected_to user_firm_parameter_path @user, @firm, @parameter
    assert_equal 'Parameter was updated', flash[:notice]
  end
 
  test "should delete parameter for admin" do
    assert_difference('Parameter.count', -1) do
      post :destroy, { user_id: @user.id.to_s, firm_id: @firm.id.to_s, id: @parameter.id }, {user_id: @admin.id}
    end
    assert_nil Parameter.find_by(id: @parameter.id)
    assert_redirected_to user_firm_parameters_path @user, @firm
    assert_equal 'Parameter was deleted', flash[:notice]
  end
# ------------------------------------------------------------
end
