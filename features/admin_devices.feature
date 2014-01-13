Feature: Admin point of view on devices
  In order to perform administrative tasks
  As an admin
  I should be able to change user's firm's devices list
  
  Background:
    Given an admin exists
    And a user exists
    And user has 2 firms
    And I log in as admin
    And I click on first user
    And users first firm has 10 devices
    And users first firm has license count 1
    And I click on users first firm
    And I click 'Registered devices'
    Then I see list of users devices
    
  Scenario: Add just one device to users first firm
    When I click 'Add device'
    And I set device_imei as `new_imei`
    And I click 'Create Device'
    Then I see 'Device was added' notification
    And I see list of users devices
    But I can not see `Add device` any more
    
  Scenario: Edit device for users first firm
    When I click `Edit` first device
    And I set device_imei as `new_imei`
    And I click 'Update Device'
    Then I see 'Device was updated' notification
    And I also see new device details
  
  Scenario: Delete device from list
    When I click `Delete` first device
    Then I see 'Device was deleted' notification
    And I see list of users devices
    And I can add +1 more devices!
    
  Scenario: Delete device from detailed view
    When I click on users first device
    And I click 'Delete'
    Then I see 'Device was deleted' notification
    And I see list of users devices
    And I can add +1 more devices!