@nightly @blue_team
Feature: REG.Admin Registration
  CR22.1 As a Central Registration Personnel I want to enter a student id so that basic student info is display and I can register the student

  CR22.2 As Central Registration Personnel I want to select a term so that I can display basic info of the term and register a student

  CR22.3 As Central Registration Personnel I want to view the Registered Courses for the Student and Term so that I can see if any additional actions are required for the registration of the student

  CR22.4 As Central Registration Personnel I want to view the Waitlisted Courses for the student and term so that I can see if any additional actions are required for the registration of the student

  CR22.5 As a Central Registration Personnel I want to enter a Course Code so that I can register a student

  CR22.6 As a Central Registration Personnel I want to enter a Section so that I can register a student for the default options (credit & registration options)

  CR22.8 As a Central Registration Personnel I want to be able to add multiple course for a student so that i can register the student for multiple courses at once

  CR22.12 As a Central Registration Personnel I want the system to perform Registration Eligibility checks once i've entered the term so that I can register the student for the correct term

  CR22.15 As a Central Registration Personnel I want to be able to remove unwanted courses i've entered before registering the student for them so that i can remove a course without registering for it

  Background:
    Given I am logged in as admin

#KSENROLL-13422
  Scenario: CR22.1.1 Verify that valid student is entered
    When I attempt to load a student by valid student Id
    Then student basic information and change term section is displayed

  Scenario: CR22.1.2 Verify error message when entering invalid student
    When I attempt to load a student by invalid student Id
    Then a validation error message displayed stating "Invalid student Id."

#KSENROLL-13424
  Scenario: CR22.2.1 Verify that valid term is entered
    When I attempt to load a Term by valid term Id
    Then term description is displayed

  Scenario: CR22.2.2 Verify error message when entering invalid term
    When I attempt to load a Term by invalid term Id
    Then error message is displayed stating "Change Term: No term defined for code:"

  Scenario: CR22.2.3 Verify error message when no term is entered
    When I attempt to load a Term without entering a term Id
    Then a required error message is displayed stating "Change Term: Term is required."

#KSENROLL-13425
  Scenario: CR22.3.1 Verify registered courses are populated and the correct credit count is shown
    When I attempt to load a Term by valid term Id
    Then registered courses are populated
    And the total number of credits for registered courses are displayed

  Scenario: CR22.3.2 Verify registered courses are populated for student with no registered courses
    When I attempt to load a Term by valid term Id for student with no registered courses
    Then registered courses are not populated

  Scenario: CR22.3.3 Verify registered courses are populated and default sort order is by course code
    When I attempt to load a Term by valid term Id
    Then the default sort order for registered courses should be on course code

#KSENROLL-13426
  Scenario: CR22.4.1 Verify waitlisted courses are populated and the correct credit count is shown
    When I attempt to load a Term by valid term Id for student with waitlisted courses
    Then waitlisted courses are populated
    And the total number of credits for waitlisted courses are displayed

  Scenario: CR22.4.2 Verify no waitlisted courses are populated for student who is not on a waitlist
    When I attempt to load a Term by valid term Id
    Then waitlisted courses are not populated

  Scenario: CR22.4.3 Verify waitlisted courses are populated and default sort order is by course code
    When I attempt to load a Term by valid term Id for student with waitlisted courses
    Then the default sort order for waitlisted courses should be on course code

#KSENROLL-13427
  Scenario: CR22.5.1 Verify that the course description appears after a valid course code is entered
    When I enter a valid course code for term
    Then the course description is displayed

  Scenario: CR22.5.2 Verify that an error message appears after an invalid course code is entered for term
    When I enter an invalid course code for term
    Then the error message for course code is displayed stating "Invalid Course Code for specified Term"

  Scenario: CR22.5.3 Verify that an error message appears after an invalid course code is entered
    When I enter an invalid course code
    Then the error message for course code is displayed stating "Invalid Course Code"

#KSENROL-13428
  Scenario: CR22.6.1 Verify that the confirm registration dialog appears after a valid section is entered
    When I enter a valid section for course code
    Then the section code should appear on the confirm registration dialog

  Scenario: CR22.6.2 Verify that an error message appears after an invalid section is entered
    When I enter an invalid section
    Then the error message for course code is displayed stating "Invalid Section for Course Code"

#KSENROLL-13722
  Scenario: CR22.8.1 Verify I am able to add multiple courses for a student when registering
    When I select the course that a student will be registered for
    Then I should be able to select additional courses for the student

#KSENROLL-13716
  Scenario: CR22.12.1 Verify that the registration tab and warning message are displayed even if the term failed the eligibility check
    When I attempt to load a Term by valid Term Id for student with Registered or Wait-listed courses
    Then a warning message along with the Registered and Wait-listed courses are displayed

  Scenario: CR22.12.2 Verify that the term eligibility check passes for a term that is open for registration
    When I open the term for registration in the Academic Calendar
    And I attempt to load a Term by valid Term Id for a student with no Registered or Wait-listed courses
    Then no failed term eligibility warning message is displayed

#KSENROLL-13720
  @wip
  Scenario: CR22.15.1 Verify I am able to add and then remove multiple courses for a student when registering
    When I select the course that a student will be registered for
    And I select additional courses to be registered for
    Then I should be able to remove all the additional courses