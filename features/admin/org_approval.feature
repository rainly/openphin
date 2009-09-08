@approval
Feature: Approving an organization
In order to increase community involvement
system organization administrators
should be able to manage organization enrollements

 Background:
    Given the following entities exist:
        | Jurisdiction      | Dallas County           |
        | Jurisdiction      | Texas                   |
        | Jurisdiction      | Tarrant County          |
        | Jurisdiction      | Denton County           |
        | Organization Type | Non-Profit Organization |
        | Role              | Public                  |
    And the following administrators exist:
        | keith@texashan.org     | Texas |
        | bob@example.com        | Dallas County |
    And the following unapproved organizations exist:
        | name                          | distribution_email            | jurisdictions                | contact_email    |
        | Gopher Lovers of America      | staff@salvationarmydallas.org | Texas, Dallas County         | john@example.com |
  Scenario: approving an organization signup
    Given I am logged in as "keith@texashan.org"
    When I go to the dashboard page
    Then I should see the organization "Gopher Lovers of America" is awaiting approval for "keith@texashan.org"

    When I follow "Approve"
    Then I should not see the organization "Gopher Lovers of America" is awaiting approval
    And "Gopher Lovers of America" contact should receive the following email:
      | subject       | Confirmation of Gopher Lovers of America organization registration    |
      | body contains | Thanks for signing up.  Your users may now begin enrollment.|
    When I sign out
    Given I am logged in as "bob@example.com"
    When I go to the dashboard page
    Then I should see the organization "Gopher Lovers of America" is awaiting approval for "bob@example.com"

    When I follow "Approve"
    Then I should not see the organization "Gopher Lovers of America" is awaiting approval
    And "Gopher Lovers of America" contact should receive the following email:
      | subject       | Confirmation of Gopher Lovers of America organization registration    |
      | body contains | Thanks for signing up.  Your users may now begin enrollment.|

Scenario: denying an organization signup
	Given I am logged in as "keith@texashan.org"
	When I go to the dashboard page
	And I follow "Deny"
	Then I should not see the organization "Gopher Lovers of America" is awaiting approval
	And "Gopher Lovers of America" contact should receive the following email:
	  | subject       | Organization registration request denied    |
      | body contains | Thanks for your organization request. |
      | body contains | Your request has been denied.         |