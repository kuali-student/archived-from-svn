@nightly
Feature: GT.Course Proposal Details Authors Collaborators

Background:
 Given I am logged in as Faculty

  Scenario: CC14.1 Add authors and collaborators to a Course Proposal
    When I create a basic course proposal with authors and collaborators
    And I perform a full search for the course proposal
    Then I should see author and collaborator details on the course proposal

  Scenario: CC14.2 Edit author and collaborator details on a course proposal
    Given I have a basic course proposal with authors and collaborators
    When I update the author and collaborator details on the course proposal
    And I perform a full search for the course proposal
    Then I should see updated author and collaborator details on the course proposal

  Scenario: CC14.3 Delete author and collaborator details from a course proposal
    Given I have a basic course proposal with authors and collaborators
    When I delete the author and collaborator details on the course proposal
    And I perform a full search for the course proposal
    Then I should no longer see author and collaborator details on the course proposal

  @draft
  Scenario Outline: 14.4 Collaborators have correct access to a draft course proposal as set by author
    Given I have a proposal with collaborators submitted as <author>
    Then <FYIViewCollaborator> can FYI the proposal
    And cannot comment on the proposal
    And <FYICommentCollaborator> can FYI and comment on the proposal
    And cannot edit the proposal
    And <FYIEditCollaborator> Edits and Submits the proposal
    Then <FYIEditCollaborator> can no longer edit the proposal
      Examples:
    |author|FYIViewCollaborator|FYICommentCollaborator|FYIEditCollaborator|
    |fred  |edna               |eric                  |earl               |


  Scenario Outline: 14.5 Collaborators have correct access to an enroute course proposal as set by author
    Given I have a proposal with submit and approve fields with collaborators submitted as <author>
    And authors and collaborators added by <approver>
    Then <FYIViewCollaborator> can FYI the proposal
    And cannot comment on the proposal
    And <AcknowledgeCommentCollaborator> can Acknowledge and Comment on the proposal
    And cannot edit the proposal
    When <ApproveEditCollaborator> Edits and Approves the proposal
    Then <ApproveEditCollaborator> can no longer edit the proposal
      Examples:
    |author|approver|FYIViewCollaborator|AcknowledgeCommentCollaborator|ApproveEditCollaborator|
    |fred  |carol   |edna               |eric                          |erin                   |