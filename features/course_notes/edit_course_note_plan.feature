@nightly
Feature: BT.Edit Course Note
  Background:
    Given I am logged in as a Student

  Scenario: NP4 1.0.1 Add course from search to planned section
    When I navigate to the planner page for a course which has note
    And  I choose to update the notes
    Then I should be able to successfully update the notes

  Scenario: NP4 1.0.2 Add course from search to planned section
    When I navigate to the planner page for a course which has note
    And  I choose to update the notes
    Then I should be able to successfully delete the notes

