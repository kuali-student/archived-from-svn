@wip
Feature: GT.Modify Course

  Background:
    Given I have an active course

  Scenario: MC1.1 Create a Modify Course Proposal as Faculty; verify can not start another
    When I create a modify course proposal as Faculty
    Then I can review the modify course proposal details compared to the course
    When I attempt to create another modify course proposal of the course
    Then I do not have the option to modify the course

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

  Scenario: MC2.1 Create and Save a Modify Proposal as CS
    Given I am logged in as Curriculum Specialist
    When I modify a course without a draft version
    Then I can review the modify proposal compared to the course

  Scenario: MC2.2 CS cannot modify with version if draft version in progress
    Given I am logged in as Curriculum Specialist
    When I attempt to modify a course with a draft version as CS
    Then I do not have the option to modify the course with version

  Scenario: MC2.3 Approve a Modify Course Proposal by CS
    Given I am logged in as Curriculum Specialist
    When I submit a modify course proposal as CS <alice>
    And I approve the modify course proposal as College_Approver <earl>
    And I approve the modify course proposal as Senate_Committee_Approver
    And I approve the modify course proposal as <publication_office_approver> adding an end term for the version to be superseded
    Then the modify course proposal is successfully approved
    And the Superseded version has a new end term and the new course version is Active

