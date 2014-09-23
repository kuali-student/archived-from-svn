@nightly @blue_team
Feature: REG.Apply Hold
  Hold2.3 As a Holds Functionary I want to apply hold
  Hold2.5 As a Holds Functionary I want to identify hold to apply

  Background:
    Given I am logged in as admin

#KSENROLL-14588
  Scenario: HOLD2.3.1 Verify that hold is applied to student
    When I apply a hold to student by completing the required information
    Then the hold exists for the student with an effective date

#KSENROLL-14588\KSENROLL-14592
  Scenario: HOLD2.3.2\HOLD2.5.1 Verify that a term based hold is applied to student
    When I apply a term based hold to student by completing the required information
    Then the hold exists for the student with an effective start term
