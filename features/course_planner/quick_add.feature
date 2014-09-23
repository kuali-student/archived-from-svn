@nightly
Feature: BT.Quick Add

  Background:
    Given I am logged in as a student registered for courses

  Scenario: PL 4.0.1 Add course to the planned section from quick add in the planner
    When I add a course from the quick add to the planned section in the planner
    Then I should be able to view the course in the planned section

  Scenario: PL 4.0.2 Do not allow  duplicate course to be added to the same section in the term
    When I add a course from the quick add to the planned section in the planner
    And I add the same course again to the same section in the term
    Then I should get a relevant exception message

  Scenario: PL 4.0.3 Add course to the backup section from quick add in the planner
    When I add a course from the quick add to the backup section in the planner
    Then I should be able to view the course in the backup section

  Scenario: PL 4.0.4 Do not allow  duplicate course to be added to the same backup section in the term
    When I add a course from the quick add to the backup section in the planner
    And I add the course again to the same backup section in the term
    Then I should get a relevant exception