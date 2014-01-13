require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
# ------------------------------------------------------------
# Should recognize validations--------------------------------
  test 'should recognize new session route' do
    assert_recognizes( { controller: "sessions", action: "new"}, log_in_path, extras={}, message=nil)
  end

  test 'should recognize destoy session route' do
    assert_recognizes( { controller: "sessions", action: "destroy"}, log_out_path, extras={}, message=nil)
  end
  
  test 'should recognize create session route' do
    assert_recognizes( { controller: "sessions", action: 'create'}, { path: sessions_path, method: :post})
  end
# ------------------------------------------------------------
# Should get validations--------------------------------------  

  test "should get new" do
    get :new
    assert_response :success
  end

end
