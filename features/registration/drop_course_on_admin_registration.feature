@nightly @blue_team
Feature: REG.Drop Course on Admin Registration
  CR23.4 As a Central Registration Personnel I want to be able to drop a course for the student and term, specifying the
         effective drop date so that i can make changes to the registered courses for the student

  Background:
    Given I am logged in as admin

#KSENROLL-13778
  Scenario: CR23.4.1 Verify that a student is no longer registered for a course after it has been dropped
    When I drop a registered course
    Then a message appears indicating that the course has been successfully dropped
    And the student is no longer registered for the course

#KSENROLL-15089
  Scenario: CR-Drop.1 Verify that a message appears when dropping a registered course after the drop period has passed
    When I attempt to drop a registered course
    Then a last day to drop message appears