@draft
Feature: Approve Course Proposal
# what's pending: approve button is not disabled when approving at department chair - KSCM-1596
  Scenario Outline: RP2.1 Submit a course proposal without all required for approve fields and verify that Reviewer cannot Approve
    Given I have a course proposal with approve fields partially completed submitted by <author>
    When I attempt to approve the course proposal as <department_chair>
    Then I cannot approve the incomplete proposal
  Examples:
    |author|department_chair|
    |fred  |carol           |
    |alice |carol           |

#what's pending: active course cannot does not appear on search results - KSCM-1806
 Scenario Outline: RP2.2 Submit a course proposal with all required for approve fields and verify reviewer can approve
    Given I have a course proposal with approve fields submitted by <author>
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


# what's pending: when department approver approves, decision rationale does not pop-up / successful approve messaging not in place - KSCM-1806
  #KSCM-2571 (Approve button appears when it should not)
  Scenario Outline: RP2.3 Reviewer can edit a submitted proposal with additional details and then approve
    Given I have a course proposal with some approve fields missing submitted by <author>
    When I review the course proposal as <department_approver>
    Then missing fields are highlighted and proposal cannot be approved
    And I complete the missing fields on the proposal and approve as <department_approver>
    And I approve the course proposal as <college_approver>
    Then I see successful approve messaging
  Examples:
    |author|department_approver|college_approver|
    |fred  |carol              |earl            |
    |alice |carol              |earl            |

  #what's pending: We see a validation message only for missing transcript title. No validation message is displayed for campus location.
  Scenario: RP3.1 CS is unable to Approve and Activate an incomplete course proposal
    When I have a credit course admin proposal with approve fields partially completed created as Curriculum Specialist
    Then missing fields are highlighted and proposal cannot be approved or activated

  #what's pending: Approve and Activate does not work and expects a final exam rationale even when standard is selected
  Scenario: RP3.2 CS can successfully Approve and Activate a complete admin proposal
    Given I have a credit course admin proposal with approve fields completed created as Curriculum Specialist
    When I approve and activate the proposal
    Then the proposal is successfully approved
    And the new course is Active


