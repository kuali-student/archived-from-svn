@nightly
Feature: GT.Modify Course

  Background:
    Given I have an active course

  Scenario: MC1.1 Create a Modify Course Proposal as Faculty; verify can not start another
    When I create a modify course proposal as Faculty
    Then I can review the modify course proposal details compared to the course
    Then I can not create another modify course

  Scenario: MC1.3 Submit Modify Proposal as Faculty
    Given there is a modify course proposal created as Faculty
    Then I cannot yet submit the modify course proposal
    When I complete the required for submit fields on the modify course proposal
    Then I can submit the modify course proposal
    And I perform a full search for the modify course proposal
    Then I can see updated status of the modify course proposal

  Scenario: MC1.4 Blanket Approve a Modify Course Proposal
    When I submit a modify course proposal as Faculty
    And I Blanket Approve the modify course proposal as CS adding an end term for the version to be superseded
    Then the modify course proposal is successfully approved
    And the Superseded version has a new end term and the new course version is Active

  @wip
  Scenario: MC2.1 Create and Save a Modify Proposal as CS
    When I create a modify course proposal as Curriculum Specialist
    Then I can review the modify proposal compared to the course
    Then I do not have the option to modify the course with new version

  @wip
  Scenario Outline: MC2.3 Approve and Activate a Modify Course Proposal by CS
    Given I submit a modify course proposal as CS by <author>
    When I approve the modify course proposal as <department_approver>
    And I approve the modify course proposal as <college_approver>
    And I approve the modify course proposal as <senate_committee_approver>
    And I approve the modify course proposal as <publication_office_approver>
    Then the modify course proposal is successfully approved
    And the Superseded version has a new end term
    And the new course version is Active
  Examples:
    |author|department_approver|college_approver|senate_committee_approver|publication_office_approver|
    |alice |carol               |earl            |martha                   |alice                      |


  @wip
  Scenario: MC3.1 Create, Approve & Activate an Admin Modify Proposal as CS
    When I modify a course without curriculum review as Curriculum Specialist
    Then I can not approve and activate the admin modify proposal
    When I complete the required for approve fields on the modify course proposal
    Then I Approve and Activate the modify course admin proposal
    And the Superseded version has a new end term
    And the new course version is Active