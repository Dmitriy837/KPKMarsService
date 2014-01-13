Feature: Exploring firm's devices
  In order to see what's really going on in my firms
  As a general user
  I should be able to explore my devices list
  
  Background:
    Given a user exists
    And user has 10 firms
    And I log in as a user
    And My first firm has 10 devices
    And My first firm has license count 1
    And I click on first firm
    And I see firms page
    And I click 'Registered devices'
    
  Scenario: Exploring devices
    And I click 'Back'
    Then I see firms page
    When I click 'Registered devices'
    Then I see list of my devices
    When I click on first device
    Then I see device details
    When I click 'Edit'
    And I click 'Back'
    Then I see device details
    When I click 'Edit'
    And I click 'Show'
    Then I see device details
    When I click 'Back'
    Then I see list of my devices
  
  Scenario: Navigation bar
    Then I see link to home in navigation bar
    And I see link to firm in navigation bar
    When I click on first device
    Then I see link to home in navigation bar
    And I see link to firm in navigation bar
    And I see link to devices in navigation bar
     
  Scenario: Edit device
    When I click `Edit` first device
    And I click 'Back'
    Then I see list of my devices    
    When I click `Edit` first device
    And I set device_imei as `new_imei`
    And I click 'Update Device'
    Then I see 'Device was updated' notification
    And I also see new device details
    
  Scenario: Delete device from list
    When I click `Delete` first device
    Then I see 'Device was deleted' notification
    And I see list of my devices
    And I can add +1 more devices!

  Scenario: Delete device from detailed view
    When I click on first device
    And I click 'Delete'
    Then I see 'Device was deleted' notification
    And I see list of my devices
    And I can add +1 more devices!
    
  Scenario: Can add 1 device, but not 2
    When I click 'Add device'
    And I set device_imei as `new_imei`
    And I click 'Create Device'
    Then I see 'Device was added' notification
    And I see list of my devices
    But I can not see `Add device` any more