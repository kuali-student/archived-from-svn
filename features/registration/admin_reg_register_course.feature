@nightly @blue_team
Feature: REG.Register Course on Admin Registration
  CR22.7 As Central Registration Personnel I want to enter a section and change the default options (if available) so that i can register a student for the selected options (credit & registration & effective date options)

  CR22.16 As a Central Registration Personnel I want to the system to display any failed eligibility check messages for the Course code as Errors with Additional Actions so that i can decide if i want to proceed with the registration or not

  CR22.17 As a Central Registration Personnel I want to view the Registered Courses for the Student and Term once I've registered him for one or more so that i can see if any additional actions are required for the registration of the student

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
    And the student is not registered for the course

  Scenario: CR22.16.2 Verify the course does not display after denying the course for registration
    When I attempt to register the student for a course with a time conflict
    Then a message indicating failed eligibility for course registration appears
    And I deny the course for registration
    And the student is not registered for the course

  Scenario: CR22.16.3 Verify the course displays after allowing the course for registration
    When I want to register a student for a course with a time conflict
    Then a message indicating failed eligibility for course registration appears
    And I allow the course for registration
    And the student is registered for the course

#KSENROLL-13715
  Scenario: CR22.17.1 Verify the course displays when course eligibility passed for registration
    When I register a student for a course that passed eligibility
    Then a message indicating the course has been successfully registered appears
    And the student is registered for the course

  Scenario: CR22.17.2 Verify the course does not display when course eligibility failed for registration
    When I attempt to register a student for a course that failed eligibility
    Then a message indicating failed eligibility for course registration appears
    And the student is not registered for the course

  Scenario: CR22.17.3 Verify the registration date is displayed as float over if the effective date has been changed
    When I change the effective date of a course before confirming registration
    Then the registration date is displayed as a float-over message

  Scenario: CR22.17.4 Verify the credit total for the term updates after registering a course
    When I register a student for a course
    Then the student's registered courses credit total for the term should be updated
