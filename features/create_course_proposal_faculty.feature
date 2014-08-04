@nightly
Feature: GT.Create a Course Proposal as Faculty

  Background:
    Given I am logged in as Faculty


  Scenario: CC2.1 Create a course proposal with required fields and review
    When I complete the required fields on the course proposal
    Then I should see data in required fields for the course proposal
    And I perform a full search for the course proposal
    Then I can review the required fields on the course proposal

  @wip
  Scenario: CC6.3 Copy a Course to a new Course Proposal
    When I find an approved Course and select copy
    Then I should see a new course proposal with a modified course title
    And I should see all the copied details on the Review Proposal page