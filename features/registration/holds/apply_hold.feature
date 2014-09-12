@blue_team
Feature:
  Hold2.3 As a Holds Functionary I want to apply hold

  Background:
    Given I am logged in as admin

@draft #KSENROLL-14588
  Scenario: HOLD2.3.1 Verify that hold is applied to student
    When I apply a hold to student by completing the required information needed for applied hold
    Then the applied hold exists in the student applied hold list