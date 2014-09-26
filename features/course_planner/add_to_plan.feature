@nightly
Feature: BT.Add note to planner

  Background:
    Given I am logged in as a Student
@smoke_test
  Scenario: PL 1.0.1 Add course from search to planned section
    When I search for a course in the course search page
    And I add the course from search to the planned section for a specific term
    Then the course should be there in the planner

  Scenario: PL 1.0.2 Add course from course details page top to planned section
    When I navigate to the course section details
    And I add the course from the course details page
    Then the course should be there in the planner

  Scenario: PL 1.0.3 Add course  from search to backup section
    When I search for a specific course
    And I add the course from search to the backup section for a specific term
    Then the course should be there in the backup section of the planner

  Scenario: PL 3.0.5 Add course offering(single activity) to a term in my plan
    When I search for a course with single activity offerings
    Then I should be able to add the course to my plan

   Scenario: PL 3.0.6 Add course offering(multiple activity) to a term in my plan
    When I add a course with multiple activity offerings to my plan
    Then the multiple activity offerings course should be successfully added to my plan

  Scenario: PL 3.0.7 Add course offering(multiple format) to a term in my plan
    When I add a course with multiple format offerings to my plan
    Then the multiple format offerings course should be successfully added to my plan