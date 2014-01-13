Given /(a|an) (.*) exists/ do |x, person|
  if person == 'admin'
    @admin = User.create(id: 1, login: "admin", password_hash: '$2a$10$3VejRP355hX/Ucs809uZf.iaW9ViOLlTsCt1rUDGXP3DQT4x0PEmi', password_salt: '$2a$10$3VejRP355hX/Ucs809uZf.' )
  else
    @user = User.create(id: 2, login: "user", password_hash: '$2a$10$3VejRP355hX/Ucs809uZf.iaW9ViOLlTsCt1rUDGXP3DQT4x0PEmi', password_salt: '$2a$10$3VejRP355hX/Ucs809uZf.' )
  end
end

Given /user has (\d+) firms/ do |n|
  (1 .. n.to_i).each do |x|
    @user.firms.create(description: "firm#{x}", license_count: x)
  end
end

Given /I log in as ?a? (.*)/ do |person|
  visit log_in_path
  if person == 'admin'
    fill_in 'login', with: @admin.login
    fill_in 'password', with: 111
    @current_user = @admin
  else
    fill_in 'login', with: @user.login
    fill_in 'password', with: 111
    @current_user = @user
  end
  click_on 'Log in'
end

Then /I see link to (.*) in navigation bar/ do |destination|
  within("div.navbar-inner") do
    case destination
    when "home"
      assert page.has_link? "HOME", href: '/'
    when "users admin room"
      assert page.has_link? @current_user.login, href: user_path(@current_user)
    when "firm"
      assert page.has_link? @firm.description, href: user_firm_path(@current_user, @firm)
    when "devices"
      assert page.has_link? "Devices", href: user_firm_devices_path(@current_user, @firm)
    when "FTP-servers"
      assert page.has_link? "FTP-servers", href: user_firm_ftp_servers_path(@current_user, @firm)
    when "parameters"
      assert page.has_link? "Parameters", href: user_firm_parameters_path(@current_user, @firm)
    end 
  end
end

Then /I see list of (my|users) (.*)/ do |x,items|
  case items
    when 'firms'
      @user.firms.each do |firm|
        page.should have_content firm.description
      end
    when 'devices'
      @firm.devices.each do |d|
        page.should have_content d.imei
      end
    when 'FTP-servers'
      #@firm.ftp_servers.each do |s|
      FtpServer.where(firm_id: @firm.id).each do |s|
        page.should have_content "#{s.url}: #{s.port}"
      end
    when 'parameters'
      @firm.parameters.each do |p|
        page.should have_content "#{p.param_name}"
      end
    when 'users'
      User.all.each do |u|
        page.should have_content "#{u.login}"
      end
  end
end

When /^I click '(.*)'$/ do |link|
  click_on link
end

When /^I click `(.*)` first (.*)/ do |action, item|
  within(page.all('tr')[0]) do
    click_on action
  end
  case item
    when 'device'
      @device = @firm.devices.first
    when 'FTP-server'
      @ftp_server = @firm.ftp_servers.first
    when 'parameter'
      @parameter = @firm.parameters.first
  end
end

Then /^I am in (.*)$/ do |path|
  current_path.should == case path
                           when 'admin room'
                             "/"
                           when 'login page'
                             "/log_in"
                           when 'settings page'
                             "/users/#{@current_user.id}/edit"
                           else
                             path
                           end
end

When /^I click on( users)? first (.*)/ do |x, item|
  click_on case item
             when 'firm'
               @firm = @current_user.firms.first
               @firm.description
             when 'device'
               @device = @firm.devices.first
               @device.imei
             when 'parameter'
               @parameter = @firm.parameters.first
               @parameter.param_name
             when 'FTP-server'
               @ftp_server = @firm.ftp_servers.first
               "#{@ftp_server.url}: #{@ftp_server.port}"
             when 'user'
             #This is not interesting to explore admin's admin room
             #the point is to check what admin can do with user's stuff
             #that's why we take here user as a current user, instead of admin
               @current_user = User.last
               "#{@current_user.login}"
             end
end

Given /first firm has (\d+) (.*)/ do |n, item|
  case item
  when 'devices'
    (1 .. n.to_i).each do |x|
      @current_user.firms.first.devices.create(imei: "imei#{x}", last_date: 40000100 + x)
    end
  when 'FTP-servers'
    (1 .. n.to_i).each do |x|
      @current_user.firms.first.ftp_servers.create(url: "url#{x}", port: 40346 + x, username: "user#{x}")
    end
  when 'parameters'
    (1 .. n.to_i).each do |x|
      @current_user.firms.first.parameters.create(param_name: "param_#{x}", param_value: "#{x}")
    end
  end
end

Then /^I see firms page$/ do
  within("body") do
    within("h1") do
      page.should have_content @firm.description
    end
    page.should have_content "Registered devices"
    page.should have_content "Registered FTP-servers"
  end
end

Then /^I see users admin room page$/ do
  within("body") do
    within("h1") do
      page.should have_content @current_user.id
    end
    @current_user.firms.each do |f|
      page.should have_content f.description
    end
  end
end

Then /see '(.*)' notification$/ do |message|
  within("#flash_notice") do
    page.should have_content message
  end
end

Then /see '(.*)' alert$/ do |message|
  within("#flash_alert") do
    page.should have_content message
  end
end

Then /I see (.*) details/ do |item|
  case item
  when 'device'
    within("body") do
      page.should have_content "Device #{@device.id}"
      page.should have_content @device.imei
    end
  when 'FTP-server'
    within("body") do
      page.should have_content "FTP-server #{@ftp_server.id}"
      page.should have_content @ftp_server.url
      page.should have_content @ftp_server.port
      page.should have_content @ftp_server.username
    end
  when 'parameter'
    within("body") do
      page.should have_content "Parameter #{@parameter.id}"
      page.should have_content @parameter.param_name
      page.should have_content @parameter.param_value
    end    
  end
end

And /I also see new (.*) details/ do |item|
  case item
  when 'device'
    within("body") do
      page.should have_content "Device #{@device.id}"
      page.should have_content "new_imei"
    end
  when 'FTP-server'
    within("body") do
      page.should have_content "FTP-server #{@ftp_server.id}"
      page.should have_content "new_url"
      page.should have_content 8080
      page.should have_content "username"
    end
  when 'parameter'
    within("body") do
      page.should have_content "Parameter #{@device.id}"
      page.should have_content "new_parameter"
      page.should have_content "new_value"
    end
  when 'firms'
    within("body") do
      page.should have_content 'new_firm'
    end
  end
end

And /(My|users) first firm has license count (\d+)/ do |x, n|
  @user.firms.first.license_count = n.to_i
end

Then /I can add \+1 more devices!/ do
  page.should have_content "Add device (#{@firm.license_count + 1} more)" 
end

Then /I can not see `(.*)` any more/ do |text|
  assert page.has_no_text? text
end

When /set (.*) as `(.*)`/ do |field, value|
  fill_in field, with: value
end