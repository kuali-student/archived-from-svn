@wip @red_team

Feature: REG.Course Repeatability
  CR 18.1 - As an administrator, I want to prevent a student from registering for a course if they have
            previously attempted it so the student complies with university policy
  CR 18.2 - As as administrator, I want to prevent a student from registering for a course if they have
            previously attempted and received a specific mark

  Background:
    Given I am logged in as a Student

#KSENROLL-14505
  Scenario: CR 18.1 Ensure student cannot register for course more than twice.
    When I attempt to register for a course that I have already taken twice

#KSENROLL-14506
  Scenario: CR 18.2 Ensure students cannot repeat a course in which they have received a specific mark
    When I attempt to register for a course that I have received a mark of I in


