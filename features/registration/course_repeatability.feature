@nightly @red_team

Feature: REG.Course Repeatability
  CR 18.1 - As an administrator, I want to prevent a student from registering for a course if they have
            previously attempted it so the student complies with university policy
  CR 18.2 - As as administrator, I want to prevent a student from registering for a course if they have
            previously attempted and received a specific mark
  CR 18.3 - As an administrator I want to warn a student when registering for a course if attempted previously
            so that they know this is the last allowed attempt
  CR 18.4 - As an administrator I want to exclude repeatable courses from the repeatability
            check so students can register for the course, repeatedly
  CR 18.9 - As an administrator I want to prevent students from registering for the same course multiple times
            in a term so that they don’t consume more than one seat in a course

  Background:
    Given I am using a mobile screen size

#KSENROLL-14505
  Scenario: CR 18.1 Ensure student cannot register for course more than the maximum allowable number of times.
    Given I log in to student registration as R.JOANL
    When I attempt to register for a course that I have already taken the maximum allowable number of times
    Then there is a message indicating that registration failed
    And there is a message indicating that I have taken the course the maximum allowable number of times
    When I view my schedule
    Then the course is not present in my schedule

#KSENROLL-14506
  Scenario: CR 18.2 Ensure students cannot repeat a course in which they have received a specific mark
    When I attempt to register for a course in which I have received a mark of I
    Then there is a message indicating that registration failed
    And there is a message indicating a course with grade I cannot be retaken
    When I view my schedule
    Then the course is not present in my schedule

#KSENROLL-14508
  Scenario: CR 18.3 Ensure student gets a warning when repeating course for the last allowable time
    When I register for a course for the second time
    Then there is a message indicating this is the last allowable repeat
    When I view my schedule
    Then the course is present in my schedule

#KSENROLL-14509
  Scenario: CR 18.4 Allow students to repeat certain courses without checking repeatability rules
    When I register for a course that is not subject to repeatability rules for the third time
    Then there is a message indicating successful registration
    And I do not receive a warning message

#KSENROLL-14887
  Scenario: CR 18.9 Prevent students from registering for multiple sections of the same course in a term
    Given I log in to student registration as student
    When I register for a course with multiple non-conflicting sections
    Then I register for a different non-conflicting section of the same course
    Then there is a message indicating that registration failed
    And there is a message indicating that I am already registered for the course
