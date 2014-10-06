@nightly
Feature: Add course to plan from bookmark

  Background:
    Given I am logged in as a Student

  Scenario: PL 2.0.1 Verify that I can add a course to plan from bookmark gutter
    When I add a course from the bookmark gutter to the planned section
    Then the course should be successfully added to the planned section

  Scenario: PL 2.0.2 Verify that I can add a course to backup from bookmark gutter
    When I add a course from the bookmark gutter to the backup section
    Then the course is successfully added to the backup section

  Scenario: PL 2.0.3 Verify that I can add a course to plan from bookmark page
    When I add a course from the bookmark page to the planned section
    Then the course should be added to the planned section

  Scenario: PL 2.0.4 Verify that I can add a course to backup from bookmark page
    When I add a course from the bookmark page to the backup section
    Then the course is added to the backup section

  Scenario: PL 2.0.5 Verify that I am not able to add a duplicate course from bookmark section
    When I try to add a duplicate course to term from the bookmark section
    Then the term is showing as planned