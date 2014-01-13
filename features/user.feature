Feature: User's admin room
  In order to see what's up in my firms
  As a general user
  I should be able to go to any of my firm's page
  
  Background:
    Given a user exists
 
  Scenario: Logging in
    Given I log in as a user
    Then I am in admin room
    And see 'Logged in' notification
	When I click 'Log out'
    Then I am in login page
    And see 'Logged out!' notification
    
  Scenario: Check my firms
    Given user has 10 firms
    Given I log in as a user
    Then I am in admin room  
    And I see list of my firms
    
  Scenario: Change my credentials
    Given I log in as a user
    Then I am in admin room
    When I click 'Settings'
    Then I am in settings page
    When I set user_login as `new_login`
    And I set user_password as `new_password`
    And I set user_old_password as `111`
    And I click 'Update User'
    Then I am in admin room
    And see 'User was updated' notification
    When I click 'Log out'
    Then I am in login page
    Given I log in as a user
    Then I see 'Invalid email or password' alert
    When I set login as `new_login`
    And I set password as `new_password`
    And I click 'Log in'
    Then I am in admin room
    And see 'Logged in' notification
    
  Scenario: See my firm's page
    Given user has 2 firms
    Given I log in as a user	
    Then I see list of my firms
    When I click on first firm
    Then I see firms page