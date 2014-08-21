@nightly
Feature: GT.Other Course Proposal Routing Actions

  Scenario Outline: RP6.1 Reviewers can return a course proposal to previous workflow node
    Given I have a course proposal with submit and approve fields submitted by <author>
    When I approve the course proposal as <department_approver>
    And I return the course proposal to Department Review as <division_approver>
    And I return the course proposal to PreRoute as <department_approver>
    Then I can resubmit the course proposal as <author>
  Examples:
      |author|department_approver|division_approver|
      |fred  |carl               |edna             |
      |alice |carl               |edna             |

@draft
  Scenario Outline: RP7.1 Node members can FYI a proposal
    Given I have a course proposal with submit and approve fields submitted by <author>
    When I FYI the course proposal as a <department_member>
    And I approve the course proposal as a <department_approver>
    Then I can FYI the course proposal as a <division_member>
  Examples:
      |author|department_member|department_approver|division_member|
      |fred  |fred             |carl               |eric           |

@draft
  Scenario Outline: RP7.2 Node members cannot FYI a proposal that isn't in their node
    Given I have a course proposal with submit and approve fields submitted by <author>
    When I find the course proposal as a <division_member>
    Then I do not have the option to FYI the proposal
  Examples:
      |author|division_member|
      |fred  |eric           |
