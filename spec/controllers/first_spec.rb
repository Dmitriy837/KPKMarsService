require 'spec_helper'

describe SessionsController, type: :controller do
  it "should encrypt password" do
     User.should_receive(:authenticate).with('login', '111')
     post "create", password: '111', login: 'login'
  end
end
