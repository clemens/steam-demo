Feature: Managing lists
  In order to have a better overview of my tasks
  As a control freak
  I want to arrange my tasks in lists

  Background:
    Given the following tasks:
      | name         | list      |
      | Mow the lawn | Garden    |
      | Sweep porch  | Garden    |
      | Buy milk     | Household |
      | Do laundry   | Household |

  Scenario: Adding a new list
    Given I am on the task list page
    When I click the link to add a new list
    And I fill in "Work" as the new list's name
    And I click somewhere else on the page
    Then there should be a list named "Work"

  Scenario: Renaming a list
    Given I am on the task list page
    When I click on "Household"
    And I fill in "House" as the list's name
    And I click somewhere else on the page
    Then there should be a list named "House"
    Then there should not be a list named "Household"

  Scenario: Reordering lists
    Given I am on the task list page
    When I drag the list "Household" above "Garden"
    Then the list "Household" should be above "Garden"

  Scenario: Deleting a list
    Given I am on the task list page
    When I hover the list "Household"
    And I click on the button to delete the list "Household"
    Then there should not be a list named "Household"
    And there should not be a task named "Buy milk"
    And there should not be a task named "Do laundry"
