@draft
Feature: Other Course Proposal Routing Actions

  Scenario Outline: RP6.1 Reviewers can return a course proposal to previous workflow node
    Given I have a course proposal with submit and approve fields submitted by <author>
    When I approve the course proposal as <department_approver>
    And I return the course proposal to Department Review as <division_approver>
    And I return the course proposal to PreRoute as <department_approver>
    Then I can resubmit the course proposal as <author>
  Examples:
      |author|department_approver|division_approver|
      |fred  |carl               |edna             |
      #|alice |carl              |edna             |