@nightly
Feature: GT.Create a Course Proposal as Faculty

  Background:
    Given I am logged in as Faculty


@smoke_test
  Scenario: CC2.1 Create a course proposal with required fields and review
    When I complete the required fields on the course proposal
    Then I should see data in required fields for the course proposal
    And I perform a full search for the course proposal
    Then I can review the required fields on the course proposal

  Scenario: CC2.2 Create a course proposal with all fields and review
    When I complete all fields on the course proposal
    And I perform a full search for the course proposal
    Then I can review all fields on the course proposal

  Scenario: CC6.3 Copy a Course to a new Course Proposal
    When I find an approved Course and select copy
    Then I should see a new course proposal with a modified course title
    And I should see all the copied details of the course on the Review Proposal page

  Scenario: CC7.3 Copy a Proposed Course to a new Course Proposal
    Given I have a course admin proposal created as Alice
    When I find a proposed course and select copy
    Then I should see a new course proposal with modified titles
    And I should see all the copied details of the proposal on the Review Proposal page