@blue_team
Feature: REG.Delete Applied Hold
  Hold2.7 As a Holds Functionary I want to delete an applied hold on the specified student so that it's no longer enforced

  Background:
    Given I am logged in as admin

#KSENROLL-14596
  @pending
  Scenario: HOLD2.6.1 Verify that an deleted hold, doesn't display for a student
    Given there exists a hold that does not maintain history
    And I apply the hold to a student
    When I delete that hold
    Then the deleted hold is displayed for the student
