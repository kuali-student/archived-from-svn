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
    And I approve the course proposal as <department_approver>
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

#Acknowledge KSCM-2604
@draft
  Scenario Outline: RP7.3 Node Chairs can Acknowledge a proposal that has been Blanket Approved when they haven't already approved
    Given I have a course proposal Blanket Approved by <blanket_approver>
    When I Acknowledge the course proposal as a <division_chair>
    Then I can see an Acknowledge decision
  Examples:
      |blanket_approver|division_chair|
      |alice           |edna          |

#Acknowledge KSCM-2604
@draft
  Scenario Outline: RP7.4 Node chairs cannot Acknowledge Blanket Approved proposals if they already approved
    Given I have a course proposal Approved by <department_chair>
    When I Blanket Approve the proposal as <blanket_approver>
    And I Acknowledge the course proposal as a <senate_reviewer>
    Then I can see the Acknowledge decisions
    And Acknowledge decision is not displayed for <department_chair>

  Examples:
      |department_chair|blanket_approver|senate_reviewer|
      |carol           |alice           | martha        |

