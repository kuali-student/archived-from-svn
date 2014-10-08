@nightly
Feature: BT.Add Note to Planner
Background:
Given I am logged in as a Student

Scenario: NP6 1.0.1  Verify a note can be added to plan via quick add in the planned section
  When I enter a note while quick adding a course to the planned section
  Then the note should be successfully entered

Scenario: NP6 1.0.2  Verify a note can be added to plan via quick add in the backup section
  When I enter a note while quick adding a course to the backup section
  Then the note should be successfully entered for the course in the backup section

Scenario: NP6 1.0.3  Verify a note can be added to plan in the course search page
  When I enter a note while adding a course to the plan in the course search page
  Then the note should be successfully entered

  Scenario: NP6 1.0.4  Verify a note can be added to plan in the course details page
    When I enter a note while  adding a course to the plan in the course details page
    Then the note should be successfully entered

