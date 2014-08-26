@nightly @red_team

Feature: REG.Course Repeatability
  CR 18.1 - As an administrator, I want to prevent a student from registering for a course if they have
            previously attempted it so the student complies with university policy
  CR 18.2 - As as administrator, I want to prevent a student from registering for a course if they have
            previously attempted and received a specific mark

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
    Given I log in to student registration as R.JODYB
    When I attempt to register for a course in which I have received a mark of I
    Then there is a message indicating that registration failed
    And there is a message indicating a course with grade I cannot be retaken
    When I view my schedule
    Then the course is not present in my schedule


