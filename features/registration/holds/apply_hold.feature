@nightly @blue_team
Feature: REG.Apply Hold
  Hold2.3 As a Holds Functionary I want to apply hold
  Hold2.5 As a Holds Functionary I want to identify hold to apply

  Background:
    Given I am logged in as admin

#KSENROLL-14588
  @draft
  Scenario: HOLD2.3.1 Verify that hold is applied to student
    When I apply a hold to student by completing the required information needed for applied hold
    Then the applied hold exists in the student applied hold list

#KSENROLL-14592
  Scenario: HOLD2.5.1 As a Holds Functionary I want to identify a hold to apply
    When I search for a hold code
    Then the selected hold code is populated