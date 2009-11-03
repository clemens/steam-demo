Feature: Managing tasks
  In order to be more organized
  As a control freak
  I want to manage my tasks

  Background:
    Given the following tasks:
      | name         | list      |
      | Mow the lawn | Garden    |
      | Sweep porch  | Garden    |
      | Buy milk     | Household |
      | Do laundry   | Household |

  Scenario: Adding a new task
    Given I am on the task list page
    When I click the link to add a new task to the list "Household"
    And I fill in "Wash dishes" as the new task's name
    And I click somewhere else on the page
    Then there should be a task named "Wash dishes" in the list "Household"

  Scenario: Reordering tasks
    Given I am on the task list page
    When I drag the task "Do laundry" above "Buy milk"
    Then the task "Do laundry" should be above "Buy milk"

  Scenario: Deleting a task
    Given I am on the task list page
    When I hover the task "Sweep porch"
    And I click on the button to delete the task "Sweep porch"
    Then there should not be a task named "Sweep porch"

  Scenario: Adding a new list
    Given I am on the task list page
    When I click the link to add a new list
    And I fill in "Work" as the new list's name
    And I click somewhere else on the page
    Then there should be a list named "Work"

  Scenario: Moving a task to another list
    Given I am on the task list page
    When I drag the task "Sweep porch" to the list "Household"
    Then there should be a task named "Sweep porch" in the list "Household"
