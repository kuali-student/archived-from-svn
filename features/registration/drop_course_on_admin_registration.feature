@nightly @blue_team
Feature: REG.Drop Course on Admin Registration
  CR23.4 As a Central Registration Personnel I want to be able to drop a course for the student and term, specifying the
         effective drop date so that i can make changes to the registered courses for the student

  Background:
    Given I am logged in as admin

#KSENROLL-13778
  Scenario: CR23.4.1 Verify that a student is no longer registered for a course after it has been dropped
    When I drop a registered course
    Then the student is no longer registered for the course
    And a message appears indicating that the course has been successfully dropped

 #KSENROLL-15089
  @pending
  Scenario: CR-Drop.1 Verify that invalid drop period is displayed for a course after it has been dropped
    When I attempt to drop a registered course
    Then a message appears indicating that the drop period is invalid