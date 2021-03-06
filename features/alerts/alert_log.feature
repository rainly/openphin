Feature: Viewing the alert log

  Scenario: Viewing list of alerts in your jurisdictions
    Given the following users exist:
      | John Smith      | john.smith@example.com   | HAN Coordinator | Dallas County |
    And the role "HAN Coordinator" is an alerter
    And I am logged in as "john.smith@example.com"
    And an alert with:
      | from_jurisdiction | Dallas County |
      | title             | Hello World   |
      | jurisdictions     | Dallas County |
      | acknowledge       | No            |
    When I am on the alert log
    Then I should see an alert titled "Hello World"
    And I should see "Acknowledge: None"
    
    When I click "View" on "Hello World"
    Then I can see the alert summary for "Hello World"
    And I should see "None" within ".acknowledge"

  Scenario: Viewing list of alerts sent directly to you
    Given the following users exist:
      | John Smith      | john.smith@example.com   | HAN Coordinator | Dallas County |
    And the role "HAN Coordinator" is an alerter
    And I am logged in as "john.smith@example.com"
    And a sent alert with:
      | from_jurisdiction | Dallas County |
      | people            | John Smith    |
      | title             | Hello World   |
      | acknowledge       | No            |
    When I am on the alert log
    Then I should see an alert titled "Hello World"
    And I should see "Acknowledge: None"

    When I click "View" on "Hello World"
    Then I can see the alert summary for "Hello World"
    And I should see "None" within ".acknowledge"

  Scenario: Viewing list of alerts in child jurisdictions
    Given the following entities exists:
      | Jurisdiction | Texas                                    |
      | Jurisdiction | Dallas County                            |
    And Texas is the parent jurisdiction of:
      | Dallas County |
    And the following users exist:
      | John Smith      | john.smith@example.com   | Health Alert and Communications Coordinator | Texas |
    And the role "Health Alert and Communications Coordinator" is an alerter
    And I am logged in as "john.smith@example.com"
    And an alert with:
      | from_jurisdiction | Dallas County |
      | title             | Hello World   |
      | jurisdictions     | Dallas County |
    When I am on the alert log
    Then I should see an alert titled "Hello World"

    When I follow "View"
    Then I should see "Hello World"

  Scenario: Can't view alerts from outside jurisdictions
    Given the following entities exists:
      | Jurisdiction | Potter County                            |
      | Jurisdiction | Dallas County                            |
    And the following users exist:
      | John Smith      | john.smith@example.com   | HAN Coordinator | Dallas County |
    And the following users exist:
      | Sam Body      | sam@example.com   | HAN Coordinator | Dallas County |

    And the role "HAN Coordinator" is an alerter
    And I am logged in as "john.smith@example.com"
    And an alert with:
      | author            | Sam Body      |
      | from_jurisdiction | Potter County |
      | title             | Hello World   |
      | jurisdiction      | Potter County |
    When I am on the alert log
    Then I should not see an alert titled "Hello World"

  Scenario: Clicking back on a viewed alert
    Given the following entities exists:
      | Jurisdiction | Texas                                    |
      | Jurisdiction | Dallas County                            |
    And Texas is the parent jurisdiction of:
      | Dallas County |
    And the following users exist:
      | John Smith      | john.smith@example.com   | HAN Coordinator | Texas |
    And the role "HAN Coordinator" is an alerter
    And I am logged in as "john.smith@example.com"
    And an alert with:
      | from_jurisdiction | Dallas County |
      | title             | Hello World   |
      | jurisdictions     | Texas |
    When I am on the alert log
    And I click "View" on "Hello World"
    And I press "Back"
    Then I should see an alert titled "Hello World"

  Scenario: Viewing percentage of recipients that have acknowledged
    Given the following entities exists:
      | Jurisdiction | Texas         |
      | Jurisdiction | Dallas County |
    And Texas is the parent jurisdiction of:
      | Dallas County |
    And the following users exist:
      | John Smith      | john.smith@example.com   | HAN Coordinator | Texas |
      | Jane Smith      | jane.smith@example.com   | HAN Coordinator | Texas |
      | Daniel Morrison | daniel@example.com       | HAN Coordinator | Texas |
    And the role "HAN Coordinator" is an alerter
    And I am logged in as "john.smith@example.com"
    When I go to the HAN
    And I follow "Send an Alert"
    And I fill out the alert form with:
      | Jurisdiction          | Texas                |
      | Jurisdictions         | Texas, Dallas County |
      | Roles                 | HAN Coordinator      |
      | Title                 | Hello World          |
      | Acknowledge           | Normal               |
      | Communication methods | E-mail, SMS          |
    And I press "Preview Message"
    Then I should see a preview of the message with:
        | Roles | HAN Coordinator |
    When I press "Send"
    And delayed jobs are processed

    And I am logged in as "jane.smith@example.com"
    And I go to the HAN
    And I follow the acknowledge alert link

    And I am logged in as "john.smith@example.com"
    And delayed jobs are processed
    When I am on the alert log
    Then I can see the alert summary for "Hello World"
    And I can see the alert for "Hello World" is 33% acknowledged
    And I can see the jurisdiction alert acknowledgement rate for "Hello World" in "Texas" is 33%
    And I can see the jurisdiction alert acknowledgement rate for "Hello World" in "Dallas County" is 0%
    And I can see the device alert acknowledgement rate for "Hello World" in "E-mail" is 33%
    And I can see the device alert acknowledgement rate for "Hello World" in "Console" is 0%
    And I can see the device alert acknowledgement rate for "Hello World" in "SMS" is 0%
    And I cannot see the device alert acknowledgement rate for "Hello World" in "Phone"
    And I cannot see the device alert acknowledgement rate for "Hello World" in "Fax"
    And I cannot see the device alert acknowledgement rate for "Hello World" in "Blackberry"
    When I go to the HAN
    And I press "Acknowledge"
    And I am on the alert log
    Then I can see the alert summary for "Hello World"
    And I should see "Acknowledge: Normal"
    And I can see the alert for "Hello World" is 67% acknowledged
    And I can see the jurisdiction alert acknowledgement rate for "Hello World" in "Texas" is 67%
    And I can see the jurisdiction alert acknowledgement rate for "Hello World" in "Dallas County" is 0%
    And I can see the device alert acknowledgement rate for "Hello World" in "E-mail" is 33%
    And I can see the device alert acknowledgement rate for "Hello World" in "Console" is 33%
    And I can see the device alert acknowledgement rate for "Hello World" in "SMS" is 0%

  Scenario: Viewing a really large alert log
    Given the following entities exist:
      | Jurisdiction | Texas |
      | Jurisdiction | R1 |
      | Jurisdiction | R2 |
      | Jurisdiction | C1 |
      | Jurisdiction | C2 |
    And Texas is the parent jurisdiction of:
      | R1|R2 |
    And R1 is the parent jurisdiction of:
      | C1|C2 |
    And 15 jurisdictions that are children of R1
    And 150 jurisdictions that are children of R2
    And 20 random alerts in R1
    And 20 random alerts in R2
    And 10 random alerts in C1
    And the following users exist:
      | John Smith      | john.smith@example.com   | HAN Coordinator | R1 |
      | John Smith      | john.smith@example.com   | HAN Coordinator | C1 |
      | John Smith      | john.smith@example.com   | HAN Coordinator | R2 |
    And "john.smith@example.com" is not public in "Texas"
    And the role "HAN Coordinator" is an alerter
    And I am logged in as "john.smith@example.com"
    When I am on the alert log
    Then I should see 10 alerts

    Scenario: Viewing acknowledged alerts with alert responses
      Given the following entities exists:
        | Jurisdiction | Texas         |
        | Jurisdiction | Dallas County |
      And Texas is the parent jurisdiction of:
        | Dallas County |
      And the following users exist:
        | John Smith      | john.smith@example.com   | HAN Coordinator | Texas |
        | Jane Smith      | jane.smith@example.com   | HAN Coordinator | Texas |
        | Daniel Morrison | daniel@example.com       | HAN Coordinator | Texas |
      And the role "HAN Coordinator" is an alerter
      And I am logged in as "john.smith@example.com"
      And an alert with:
        | from_jurisdiction | Texas                |
        | jurisdictions     | Texas, Dallas County |
        | roles             | HAN Coordinator      |
        | title             | Hello World          |
        | communication methods | Email, SMS       |
        | alert_response_1  | if you can respond within 15 minutes |
        | alert_response_2  | if you can respond within 30 minutes |
        | alert_response_3  | if you can respond within 1 hour     |
        | alert_response_4  | if you can respond within 4 hours    |
        | alert_response_5  | if you cannot respond                |
      And "jane.smith@example.com" has acknowledged the alert "Hello World"
      And "john.smith@example.com" has not acknowledged the alert "Hello World"
      And "daniel@example.com" has not acknowledged the alert "Hello World"
      When I am on the alert log
      Then I can see the alert summary for "Hello World"
      Then I should see "Acknowledge: Advanced"
      When I go to the HAN
      And I should see "Alert Response"
      And I select "if you can respond within 15 minutes" from "Alert Response"
      And I press "Acknowledge"
      
    Scenario: Viewing acknowledged alerts with alert responses from view
      Given the following entities exists:
        | Jurisdiction | Texas         |
        | Jurisdiction | Dallas County |
      And Texas is the parent jurisdiction of:
        | Dallas County |
      And the following users exist:
        | John Smith      | john.smith@example.com   | HAN Coordinator | Texas |
        | Jane Smith      | jane.smith@example.com   | HAN Coordinator | Texas |
        | Daniel Morrison | daniel@example.com       | HAN Coordinator | Texas |
      And the role "HAN Coordinator" is an alerter
      And I am logged in as "john.smith@example.com"
      And an alert with:
        | from_jurisdiction | Texas                |
        | jurisdictions     | Texas, Dallas County |
        | roles             | HAN Coordinator      |
        | title             | Hello World          |
        | communication methods | Email, SMS       |
        | alert_response_1  | if you can respond within 15 minutes |
        | alert_response_2  | if you can respond within 30 minutes |
        | alert_response_3  | if you can respond within 1 hour     |
        | alert_response_4  | if you can respond within 4 hours    |
        | alert_response_5  | if you cannot respond                |
      And "jane.smith@example.com" has acknowledged the alert "Hello World"
      And "john.smith@example.com" has not acknowledged the alert "Hello World"
      And "daniel@example.com" has not acknowledged the alert "Hello World"
      When I go to the HAN
      Then I should see "Alert Response"
      When I select "if you can respond within 15 minutes" from "Alert Response"
      And I press "Acknowledge"
      When I am on the alert log
      Then I can see the alert summary for "Hello World"
      When I click "View" on "Hello World"
      Then I should see "if you can respond within 15 minutes"
      When I go to the HAN
      Then I should not see "Alert Response"
      
    Scenario: Viewing audience of Alert and acknowledgement log from view(show)
      Given the following entities exists:
        | Jurisdiction | Texas         |
        | Role         | Health Officer |
      And the following users exist:
        | John Smith      | john.smith@example.com   | HAN Coordinator | Texas |
        | Jane Smith      | jane.smith@example.com   | Health Officer  | Texas |
        | Daniel Morrison | daniel@example.com       | Health Officer | Texas |
      And the role "HAN Coordinator" is an alerter
      And I am logged in as "john.smith@example.com"
      And I've sent an alert with:
        | Jurisdiction      | Texas                |
        | Jurisdictions     | Texas                |
        | Roles             | Health Officer       |
        | People            | John Smith           |
        | Title             | Hello World          |
        | Communication methods | E-mail           |
        | Alert Response 1  | if you can respond within 15 minutes |
        | Alert Response 2  | if you can respond within 30 minutes |
        | Alert Response 3  | if you can respond within 1 hour     |
        | Alert Response 4  | if you can respond within 4 hours    |
        | Alert Response 5  | if you cannot respond                |
      And delayed jobs are processed
      And "jane.smith@example.com" has acknowledged the alert "Hello World" with "" 0 minutes later
      And I follow the acknowledge alert link
      And "daniel@example.com" has acknowledged the alert "Hello World" with "if you cannot respond" 0 minutes later 
      And delayed jobs are processed
      When I am on the alert log
      Then I can see the alert summary for "Hello World"
      When I click "View" on "Hello World"
      
      Then I should see "Texas" within ".jurisdictions"
      And I should see "Health Officer" within ".roles"
      And I should see "John Smith" within ".people"
      And I should see "if you cannot respond" within ".alert_response"