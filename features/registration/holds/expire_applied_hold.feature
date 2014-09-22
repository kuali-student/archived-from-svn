@nightly @blue_team
Feature: REG.Expire Applied Hold
  Hold 2.14 As a Holds Functionary I want the system not to display expired holds if the maintain history is set to false

  Background:
    Given I am logged in as admin

#KSENROLL-14604
  Scenario: HOLD2.14.1 Verify that an expired hold, that's not set to maintain history, doesn't display for a student
    Given there exists a hold that does not maintain history
    And I apply the hold to a student
    When I expire that hold
    Then the hold is no longer displayed for the student

#KSENROLL-14604
  Scenario: HOLD2.14.2 Verify that an expired hold, that's set to maintain history, displays for a student
    Given there exists a hold that maintains history
    And I apply the hold to a student
    When I expire that hold
    Then the expired hold is displayed for the student