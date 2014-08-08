@draft
Feature: Approve Course Proposal
# what's pending: approve button is not disabled when approving at department chair
 Scenario Outline: RP2.1 Partial create a course proposal and verify that Reviewer cannot Approve
    Given I have a course proposal with approve fields partially completed created as <author>
    When I attempt to approve the course proposal as <department_chair>
    Then I cannot approve the incomplete proposal
  Examples:
    |author|department_chair|
    |fred  |carol           |
    |alice |martha          |

#what's pending: active course cannot does not appear on search results.
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


# what's pending: when department approver approves, decision rationale does not pop-up / successful approve messaging not in place.
  Scenario Outline: RP2.3 Reviewer can edit a proposal with additional details and then approve
    Given I have a partial completed course proposal created as <author>
    When I approve the course proposal as <department_approver>
    And I review the proposal as <college_approver>
    Then missing fields are highlighted and proposal cannot be approved
    And I complete the missing fields on the proposal and approve as <college_approver>
    Then I see successful approve messaging
  Examples:
    |author|department_approver|college_approver|
    |fred  |carol              |earl            |
    |alice |carol              |earl            |