@nightly
Feature: GT.Print and Export

  Scenario:PE1.1 Authors can Print and Export Draft Course Proposals
    When I create a basic course proposal as Faculty
    Then I can print the course proposal
    And export the course proposal

  Scenario: PE1.2 Authorized viewers can Print and Export Enroute Course Proposals
    Given I have a course proposal submitted as Faculty
    When I review course proposal as a Reviewer
    Then I can print the course proposal
    And export the course proposal

  Scenario: PE1.3 Authorized viewers can Print and Export Approved Course Details
    Given I am logged in as Faculty
    When I view the course details using Find a Course
    Then I can print the course details
    And export the course details