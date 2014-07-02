@nightly
Feature: GT.Course Proposal Details Authors Collaborators

Background:
 Given I am logged in as Faculty

  Scenario: CC14.1 Add authors and collaborators to a Course Proposal
    When I create a basic course proposal with authors and collaborators
    And I perform a full search for the course proposal
    Then I should see author and collaborator details on the course proposal

  Scenario: CC14.2 Edit author and collaborator details on a course proposal
    Given have a basic course proposal with authors and collaborators
    When I update the author and collaborator details on the course proposal
    And I perform a full search for the course proposal
    Then I should see updated author and collaborator details on the course proposal

  Scenario: CC14.3 Delete author and collaborator details from a course proposal
    Given have a basic course proposal with authors and collaborators
    When I delete the author and collaborator details on the course proposal
    And I perform a full search for the course proposal
    Then I should no longer see author and collaborator details on the course proposal