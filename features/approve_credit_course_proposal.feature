@draft
Feature: Approve Course Proposal

 Scenario Outline: RP2.1 Partial create a course proposal as Faculty and verify that Reviewer cannot Approve
    Given I have a course proposal with approve fields partially completed created as <author>
    When I attempt to approve the course proposal as <department_level_chair>
    Then I cannot approve the incomplete proposal
    And I attempt to approve or acknowledge the course proposal as <department_level_committee>
    Then I cannot approve or acknowledge the incomplete proposal
  Examples:
    |author|department_level_chair|department_level_committee|
    |fred  |martha                |doug                      |
    |alice |martha                |doug                      |


 Scenario Outline: RP2.2 Create a course proposal with approve fields as Faculty and verify reviewer can approve
    Given I have a course proposal with approve fields created as <author>
    When I approve the course proposal as <department_approver>
    And I approve the course proposal as <division_approver>
    And I approve the course proposal as <college_approver>
    And I approve the course proposal as <senate_committee_approver>
    And I approve the course proposal as <publication_office_approver>
    Then the course proposal is successfully approved
    And the new course is Active
  Examples:
    |author|department_approver|division_approver|college_approver|senate_committee_approver|publication_office_approver|
    |fred  |carl               |edna             |erin            |martha                   |alice                      |
    |alice |carl               |edna             |erin            |martha                   |alice                      |



  Scenario Outline: RP2.3 Partial create a course proposal as Faculty, complete proposal and approve as reviewer.
    Given I have a partial completed course proposal created as <author>
    When I review the proposal as <department_approver>
    Then missing fields are highlighted and proposal cannot be approved
    And I complete the missing fields on the proposal
    And I approve the course proposal as <college_approver>
    And I approve the course proposal as <senate_committee_approver>
    And I approve the course proposal as <publication_office_approver>
    Then the course proposal is successfully approved
    And the new course is Active
  Examples:
    |author|department_approver|college_approver|senate_committee_approver|publication_office_approver|
    |fred  |carol              |earl            |martha                   |alice                      |
    |alice |carol              |earl            |martha                   |alice                      |