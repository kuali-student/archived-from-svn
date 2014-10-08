@nightly @blue_team
Feature: REG.Register Course on Admin Registration
  CR22.7  As Central Registration Personnel I want to enter a section and change the default options (if available) so
          that i can register a student for the selected options (credit & registration & effective date options)
  CR22.16 As a Central Registration Personnel I want to the system to display any failed eligibility check messages for
          the Course code as Errors with Additional Actions so that i can decide if i want to proceed with the registration or not
  CR22.17 As a Central Registration Personnel I want to view the Registered Courses for the Student and Term once I've
          registered him for one or more so that i can see if any additional actions are required for the registration of the student

  Background:
    Given I am logged in as admin

#KSENROLL-13367
  Scenario: CR22.7.1 Verify default values are displayed for a specified course
    When I attempt to register a student for a course with default values for Credit and Registration Options
    Then the default values are displayed when confirming registration

  Scenario: CR22.7.2 Verify default date is on the confirm registration dialog for specified course
    When I attempt to register a student for a course
    Then the effective date should default to system date

  Scenario: CR22.7.3 Verify error message appears when attempting to register for cancelled course section
    When I attempt to register a student for a cancelled course section
    Then an error message appears indicating that the section was cancelled for the selected term

#KSENROLL-13776
  Scenario: CR22.16.1 Verify multiple course eligibility failed messages appear
    When I register a student for courses with more credits than the allowed maximum
    And I register the student for a course with a time conflict
    Then multiple failed eligibility messages appear

  @smoke_test
  Scenario: CR22.16.2 Verify that the course displays even though the course failed eligibility for registration
    When I want to register a student for a course with a time conflict
    Then a message indicating failed eligibility for course registration appears
    But the student is still registered for the course

#KSENROLL-13715
  Scenario: CR22.17.1 Verify the course displays when course eligibility passed for registration
    When I register a student for a course that passed eligibility
    Then a message indicating the course has been successfully registered appears
    And the student is registered for the course

  Scenario: CR22.17.2 Verify the credit total for the term updates after registering a course
    When I register a student for a course
    Then the student's registered courses credit total for the term should be updated

#KSENROLL-14116
  Scenario: CR-Register.1 Verify that a course repeatability message appears when registering a student for a previously enrolled course
    Given a student was registered for a course in a previous term
    When I register the student for the same course in a following term
    Then a course repeatability message appears
    But the student is still registered for the course

#KSENROLL-15067
  Scenario: CR-Register.2 Verify that an error message appears when attempting to register a student for a course with a suspended section
    When I attempt to register a student for a course with a suspended section
    Then a suspended section error message appears

  Scenario: CR-Register.3 Verify that an error message appears when attempting to register a student for a course with a pending state
    When I attempt to register a student for the course with a pending state
    Then a course not offered error message appears

#KSENROLL-15091
  Scenario: CR-Register.4 Verify that a message appears when registering a student for a course more than once in a term
    When I register a student for the course more than once
    Then an already registered message appears

#KSENROLL-15114
  Scenario: CR-Register.5 Verify that a message appears when registering a student out of his registration appointment time window
    When I register a student out of his registration appointment time window
    Then an invalid Registration Appointment date message appears