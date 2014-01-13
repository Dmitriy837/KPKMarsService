Feature: Firms parameters
  In order to perform administrative tasks
  As an admin
  I should be able to change user's firm's parameters list
  
  Background:
    Given an admin exists
    And a user exists
    And user has 2 firms
    And I log in as admin
    And I click on first user
    And users first firm has 10 parameters
    And I click on users first firm
    And I click 'Parameters'
    Then I see list of users parameters
    
  Scenario: Add parameter to users first firm
    When I click 'Add parameter'
    And I set parameter_param_name as `new_param`
    And I set parameter_param_value as `new_value`
    And I click 'Create Parameter'
    Then I see 'Parameter was added' notification
    And I see list of users parameters
    
  Scenario: Edit parameter for users first firm
    When I click `Edit` first parameter
    And I set parameter_param_name as `new_parameter`
    And I set parameter_param_value as `new_value`
    And I click 'Update Parameter'
    Then I see 'Parameter was updated' notification
    And I also see new parameters details
  
  Scenario: Delete parameter from list
    When I click `Delete` first parameter
    Then I see 'Parameter was deleted' notification
	And I see list of users parameters

  Scenario: Delete parameter from detailed view
    When I click on users first parameter
    And I click 'Delete'
    Then I see 'Parameter was deleted' notification
    And I see list of users parameters