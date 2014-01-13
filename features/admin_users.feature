Feature: Browsing users
  In order to perform administrative tasks
  As an admin
  I should be able to explore users admin rooms
  
  Background:
    Given an admin exists
    And a user exists
    And user has 2 firms
    And I log in as admin
    And I am in admin room
    And I see list of my users
    And I click on first user
    
  Scenario: Exploring users
    Then I see users admin room page
    And I see link to home in navigation bar
    When I click on users first firm
    Then I see firms page
    When I click 'Back'
    Then I see users admin room page
    When I click 'Back'
    Then I see list of my users
    
  Scenario: Changing users credentials
    And I click 'Edit'
    When I set user_login as `new_login`
    And I set user_password as `new_password`
    And I set user_old_password as `111`
    And I click 'Update User'
    Then I am in admin room
    And see 'User was updated' notification
    
  Scenario: Explore users devices
    Given user's first firm has 2 devices
    When I click on users first firm
    And I click 'Registered devices'
    Then I see list of users devices
    When I click on first device
    Then I see device details
    And I see link to home in navigation bar
    And I see link to users admin room in navigation bar
    And I see link to firm in navigation bar
    And I see link to devices in navigation bar
    When I click 'Edit'
    And I click 'Back'
    Then I see device details
    When I click 'Back'
    Then I see list of users devices
    When I click `Edit` first device
    And I click 'Back'
    Then I see list of users devices
    When I click 'Back'
    Then I see firms page
    
  Scenario: Explore users FTP-servers
    Given user's first firm has 2 FTP-servers
    When I click on users first firm
    And I click 'Registered FTP-servers'
    Then I see list of users FTP-servers
    When I click on first FTP-server
    Then I see FTP-server details
    And I see link to home in navigation bar
    And I see link to users admin room in navigation bar
    And I see link to firm in navigation bar
    And I see link to FTP-servers in navigation bar
    When I click 'Edit'
    And I click 'Back'
    Then I see FTP-server details
    When I click 'Back'
    Then I see list of users FTP-servers
    When I click `Edit` first FTP-server
    And I click 'Back'
    Then I see list of users FTP-servers
    When I click 'Back'
    Then I see firms page
  
  Scenario: Explore users parameters
    Given user's first firm has 2 parameters
    When I click on users first firm
    And I click 'Parameters'
    Then I see list of users parameters
    When I click on first parameter
    Then I see parameter details
    And I see link to home in navigation bar
    And I see link to users admin room in navigation bar
    And I see link to firm in navigation bar
    And I see link to parameters in navigation bar
    When I click 'Edit'
    And I click 'Back'
    Then I see parameter details
    When I click 'Back'
    Then I see list of users parameters
    When I click `Edit` first parameter
    And I click 'Back'
    Then I see list of users parameter
    When I click 'Back'
    Then I see firms page