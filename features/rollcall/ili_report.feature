Feature: A school submitting ILI report
  In order to submit data when I don't have an automated process
  As a school user
  I can submit ILI data
  
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
    And the following symptoms exist:
      | Headache   |
      | Diarrhea   |
      | Cough      |
      | Rhinorrhea |
      
  Scenario: A user submitting an ILI report with only required fields
    Given I am logged in as "nurse.betty@example.com"
    When I go to the rollcall schools page
    Then 0 ILI reports should exist for "Lewis Elementary"
    When I follow "Submit ILI Report"
    And I select "LEWIS ES" from "Facility"
    And I fill in "Temperature" with "101"
    And I check "Headache"
    And I check "Diarrhea"
    And I check "Rhinorrhea"
    And I fill in "Date of onset of symptoms" with "07/08/2009"
    And I check "In school at time of onset of symptoms"
    And I fill in "Grade Level" with "9"
    And I fill in "Home zip code of student" with "49423"
    And I select "Male" from "Gender of student"
        
    And I press "Submit"
    Then I should see "Successfully submitted"
    And 1 ILI reports should exist for "Lewis Elementary"
    
  Scenario: A user submitting an ILI report with only required fields
    Given I am logged in as "nurse.betty@example.com"
    And a HIPAA agreement is on file for "Houston ISD"
    When I go to the rollcall schools page
    Then 0 ILI reports should exist for "Lewis Elementary"
    When I follow "Submit ILI Report"
    And I select "LEWIS ES" from "Facility"
    And I fill in "Temperature" with "101"
    And I check "Headache"
    And I check "Diarrhea"
    And I check "Rhinorrhea"
    And I fill in "Date of onset of symptoms" with "07/08/2009"
    And I check "In school at time of onset of symptoms"
    And I fill in "Grade Level" with "9"
    And I fill in "Home zip code of student" with "49423"
    And I select "Male" from "Gender of student"

    And I fill in "Student's name" with "Nick Sess"
    And I fill in "Parent's name" with "Pa Sess"
    And I fill in "Student's Home address" with "123 Any Street"
    And I fill in "Student's date of birth" with "03/04/1995"
    And I fill in "Student's race" with "Native American"
    And I fill in "Student's phone number" with "555-555-0123"

    And I press "Submit"
    Then I should see "Successfully submitted"
    And 1 ILI reports should exist for "Lewis Elementary"
