Feature: A school submitting attendance data
  In order to submit data when I don't have an automated process
  As a school user
  I can submit attendance data
  
  Background:
    Given the following entities exist:
      | Role         | SchoolNurse     |
      | Role         | Epidemiologist  |
      | Jurisdiction | Texas           |
      | Jurisdiction | Houston         |
    And Texas is the parent jurisdiction of:
      | Houston |
    And Houston has the following school districts:
      | Houston ISD |
    And "Houston ISD" has the following schools:
      | Name                 | DisplayName | SchoolID | Level |
      | Lewis Elementary     | LEWIS ES    | 1        | ES    |
    And the following users exist:
      | Nurse Betty  | nurse.betty@example.com | SchoolNurse    | Houston |
      | Nurse Betty  | nurse.betty@example.com | Rollcall       | Houston |
  
  @wip    
  Scenario: A user submitting attendance data
    Given I am logged in as "nurse.betty@example.com"
    When I go to the rollcall schools page
    Then an absentee report should not exist for "Lewis Elementary" on "01/01/2009"
    When I follow "Submit Attendance Data"
    And I select "LEWIS ES" from "Facility"
    And I fill in "Reporting Date" with "01/01/2009"
    And I fill in "Enrollment" with "1000"
    And I fill in "Absent" with "13"
    And I fill in "Absent due to ILI" with "2"
    And I fill in "Left early due to illness" with "3"
    And I fill in "Left early due to ILI" with "4"
    And I select "Staying the same" from "The number of students at your facility is"
    And I uncheck "Facility closed"
    And I uncheck "If yes, was it closed for the flu?"
    And I fill in "Faculty Absent" with "5"
    And I fill in "Faculty with ILI" with "1"
    And I fill in "Comments" with "Lots of runny noses!"
    And I press "Submit"
    Then I should see "Successfully submitted"
    And an absentee report should exist for "Lewis Elementary" on "01/01/2009"
    