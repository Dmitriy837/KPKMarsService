Feature: Admin point of view on FTP-servers
  In order to perform administrative tasks
  As an admin
  I should be able to change user's firm's FTP-servers list
  
  Background:
    Given an admin exists
    And a user exists
    And user has 2 firms
    And I log in as admin
    And I click on first user
    And users first firm has 10 FTP-servers
    And I click on users first firm
    And I click 'Registered FTP-servers'
    Then I see list of users FTP-servers
      
  Scenario: Add FTP-server to users first firm
    When I click 'Add FTP-server'
    And I set ftp_server_url as `127.0.0.1`
    And I set ftp_server_port as `34567`
    And I set ftp_server_username as `username`
    And I click 'Create Ftp server'
    Then I see 'FTP-server was added' notification
    And I see list of users FTP-servers
    
  Scenario: Edit FTP-server for users first firm
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
    And I see list of users FTP-servers

  Scenario: Delete FTP-server from detailed view
    When I click on users first FTP-server
    And I click 'Delete'
    Then I see 'FTP-server was deleted' notification
    And I see list of users FTP-servers