@draft
Feature: GT.Retire a Course

  Scenario: RC1.1 Verify that a proposal to retire and course can be submitted successfully
    Given I have an active course
    When I create a retire course proposal as Faculty
    Then I can review the retire course proposal details
    When I submit the retire course proposal
    And I approve the retire course proposal as Department Chair
    And I blanket approve the retire course proposal as Curriculum Specialist
    Then the retire course proposal is successfully approved
    And a new course version is created with a state of Retired
    And the previous version has been Superseded

  Scenario: RC1.2 Cannot retire as Faculty if retire proposal already in progress
    Given there is a retire course proposal created as Curriculum Specialist
    When I attempt to create a second retire proposal as Faculty
    Then I do not have the option to retire the course

  Scenario: RC1.3 Submit Retire Proposal as Faculty
    When I create a retire course proposal with a missing required for submit detail as Faculty
    Then I cannot yet submit the retire course proposal
    When I complete the required for submit fields on the retire course proposal
    Then I can submit the retire course proposal
    And I perform a full search for the retire course proposal
    Then I can see updated status of the retire course proposal

  Scenario: RC1.4 Approve and Retire a Retire Course Proposal
    When I submit a retire course proposal with all fields complete as Faculty
    And I approve the retire course proposal as College Approver
    And I blanket approve the retire course proposal as Curriculum Specialist
    Then the retire course proposal is successfully approved
    And a new course version is created with a state of Retired
    And the previous version has been Superseded


