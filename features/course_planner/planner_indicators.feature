@wip
Feature: BT.Quick Add

  Background:
    Given I am logged in as a student registered for courses

  Scenario: PL 4.0.1 Verify the indicator for a course that is not in the list of published schedule of classes
    When I search for a course that in not in the list of published schedule of classes
    And I navigate to the Planner page
    Then the course should indicate that it is not offered for the term



