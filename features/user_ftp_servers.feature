Feature: Exploring firm's FTP-servers
  In order to see what's really going on in my firms
  As a general user
  I should be able to explore my FTP-servers list
  
  Background:
    Given a user exists
    And user has 10 firms
    And I log in as a user
    And My first firm has 10 FTP-servers
    And I click on first firm
    And I see firms page
    And I click 'Registered FTP-servers'
    
  Scenario: Exploring FTP-servers
    And I click 'Back'
    Then I see firms page
    When I click 'Registered FTP-servers'
    Then I see list of my FTP-servers
    When I click on first FTP-server
    Then I see FTP-server details
    When I click 'Edit'
    And I click 'Back'
    Then I see FTP-server details
    When I click 'Edit'
    And I click 'Show'
    Then I see FTP-server details
    When I click 'Back'
    Then I see list of my FTP-servers
    
  Scenario: Navigation bar
    Then I see link to home in navigation bar
    And I see link to firm in navigation bar
    When I click on first FTP-server
    Then I see link to home in navigation bar
    And I see link to firm in navigation bar
    And I see link to ftp_servers in navigation bar
      
  Scenario: Edit FTP-servers
    When I click `Edit` first FTP-server
    And I click 'Back'
    Then I see list of my FTP-servers    
    When I click `Edit` first FTP-server
    And I set ftp_server_url as `new_url`
    And I set ftp_server_port as `8080`
    And I set ftp_server_username as `username`
    And I click 'Update Ftp server'
    Then I see 'FTP-server was updated' notification
    And I also see new FTP-server details
    
  Scenario: Delete FTP-server from list
    When I click `Delete` first FTP-server
    Then I see 'FTP-server was deleted' notification
	And I see list of my FTP-servers

  Scenario: Delete FTP-server from detailed view
    When I click on first FTP-server
    And I click 'Delete'
    Then I see 'FTP-server was deleted' notification
    And I see list of my FTP-servers
    
  Scenario: Add FTP-server
    When I click 'Add FTP-server'
    And I set ftp_server_url as `new_url`
    And I set ftp_server_port as `8080`
    And I set ftp_server_username as `username`
    And I click 'Create Ftp server'
    Then I see 'FTP-server was added' notification
    And I see list of my FTP-servers