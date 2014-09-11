@nightly @blue_team
Feature: REG.Manage Hold
  Hold2.1 As a Holds Functionary I want to enter a student id so that basic student info is displayed
  Hold2.2 As a Holds Functionary or Admin I want to view the applied holds for the specified student

  Background:
    Given I am logged in as admin

  #KSENROLL-14582
  Scenario: HOLD2.1.1 Verify that student info is displayed after valid student is entered
    When I attempt to load a student by valid student Id
    Then the student information is displayed

#KSENROLL-14582
  Scenario: HOLD2.1.2 Verify error message when entering invalid student
    When I attempt to load a student by invalid studentId
    Then a validation error is displayed stating "Student ID: Invalid student Id."

#KSENROLL-14586
  Scenario: HOLD2.2.1 Verify that applied holds are displayed after a valid student is entered
    When I attempt to load a student by valid student Id
    Then the applied hold information is displayed