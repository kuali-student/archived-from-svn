@wip
Feature: BT.Planner Indicators and Real Time Data

  Background:
    Given I am logged in as a student registered for courses

  Scenario: VP 5.0.1 Verify the indicator for a course that is not in the list of published schedule of classes
    When I search for a course that in not in the list of published schedule of classes
    And I navigate to the Planner page
    Then the course should indicate that it is not offered for the term



