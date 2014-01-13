Feature: Browsing firms
  In order to perform administrative tasks
  As an admin
  I should be able to change user's firm's list
  
  Background:
    Given an admin exists
    And a user exists
    And user has 2 firms
    And I log in as admin
    And I click on first user
    
  Scenario: Add firm to user
    When I click 'Add firm'
    And set firm_description as `new_firm`
    And set firm_license_count as `30`
    And I click 'Create Firm'
    Then I see 'Firm was added' notification
    And I see users admin room page
    
  Scenario: Edit firm for user
    When I click on first firm
    And I click 'Edit'
    And set firm_description as `new_firm`
    And set firm_license_count as `30`
    And I click 'Update Firm'
    Then I see 'Firm was updated' notification
    And I also see new firms details
    
  Scenario: Delete firm from user
     When I click on first firm
     And I click 'Delete'
     Then I see 'Firm was deleted' notification
     And I see users admin room page