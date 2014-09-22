@wip
Feature: BT.Planner Indicators and Real Time Data

  Background:
    Given I am logged in as a student registered for courses

  Scenario: VP 5.0.1 Verify the indicator for a course that is not in the list of published schedule of classes
    When I search for a course that in not in the list of published schedule of classes
    And I navigate to the Planner page
    Then the course should indicate that it is not offered for the term

  Scenario: VP 5.0.2 Verify the indicator for a course that has retired with a past expiration date
    When I navigate to the planner page to view a planned course that has retired with a past expiration date
    Then the course should indicate that it is not offered for the term

  Scenario: VP 5.0.3 Verify the indicator for a course planned for suspended or cancelled registration groups
    When I navigate to the planner page to view a course planned for suspended or cancelled registration groups
    Then the course should indicate that the registration group has been suspended or cancelled


  Scenario: VP 5.0.4 Verify the indicator for a course planned for suspended or cancelled course offering
    When I navigate to the planner page to view a course planned for suspended or cancelled course offering
    Then the course should indicate that the registration group has been cancelled or suspended




