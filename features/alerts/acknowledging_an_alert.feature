Feature: Acknowledging an Alert
  In order to inform the alerters
  As a user
  I can acknowledge an alert
  
  Background: 
    Given the following entities exists:
      | Organization | Red Cross             |
      | Jurisdiction | Texas                 |
      | Jurisdiction | Dallas County         |
      | Jurisdiction | Tarrant County        |
      | Role         | Health Officer        |
      | Role         | Immunization Director |
    And the following users exist:
      | Ethan Waldo     | ethan.waldo@example.com    | Health Officer  | Tarrant County |
      | Keith Gaddis    | keith.gaddis@example.com   | Epidemiologist  | Wise County    |
      
    And Texas is the parent jurisdiction of:
      | Dallas County | Tarrant County | Wise County | Potter County |  
    And the following users belong to the Red Cross:
      | Ethan Waldo |
      
    And I am logged in as "ethan.waldo@example.com"
  
  Scenario: Acknowledging an alert
    Given an alert with: 
      | identifier | CDC-2006-183 |
      | People     | Keith Gaddis |
    When I view the alert identified by CDC-2006-183
    And I press "Acknowledge"
    Then I should see "You have Acknowledged this Alert"
    
    When I login as the author of the alert identified by CDC-2006-183
    And I view the alert identified by CDC-2006-183
    Then I can see that "Keith Gaddis" acknowledged the alert