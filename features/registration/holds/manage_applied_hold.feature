@nightly @blue_team
Feature: REG.Manage Applied Hold
  Hold2.1 As a Holds Functionary I want to enter a student id so that basic student info is displayed
  Hold2.2 As a Holds Functionary or Admin I want to view the applied holds for the specified student
  Hold2.18 As a Holds Functionary I want to see the Hold Catalog Info of any applied or expired hold on a student

  Background:
    Given I am logged in as admin

#KSENROLL-14582\#KSENROLL-14586
  Scenario: HOLD2.1.1\HOLD2.2.1 Verify that student info is displayed after valid student is entered
    When I attempt to load a student by valid student Id
    Then the student information is displayed
    And the applied hold information is displayed

  Scenario: HOLD2.1.2 Verify error message when entering invalid student
    When I attempt to load a student by invalid studentId
    Then a validation error is displayed stating "Student ID: Invalid student Id"

#KSENROLL-14575
  Scenario: Hold2.18.1 Verify that the hold issue's catalog information is displayed on the inquiry view
    When I load a student to view the hold code information
    Then the inquiry view displays the hold catalog information