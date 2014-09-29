@nightly
Feature: GT.Retire a Course

  Scenario: RC1.1 Create and save a Retire Proposal as Faculty
    Given I have an active course with 911 created for modify
    When I create a retire course proposal as Faculty
    Then I can review the retire course proposal details

  Scenario: RC1.2 Verify Faculty cannot create a retire course proposal when a retire proposal is already in progress
    Given I have an active course with 912 created for modify
    And there is a retire course proposal created as Curriculum Specialist
    When I attempt to create a second retire proposal on the same course as Faculty
    Then I do not have the option to retire the course

  Scenario: RC1.3 Verify Faculty can only submit a Retire Proposal with required for submit fields populated
    Given I have an active course with 913 created for modify
    When I create a retire course proposal with a missing required for submit detail as Faculty
    Then I cannot yet submit the retire course proposal
    When I complete the required for submit fields on the retire course proposal
    Then I can submit the retire course proposal
    And I perform a full search for the retire course proposal
    Then I can see updated status of the retire course proposal

  Scenario: RC1.4 Verify retire course proposal can be approved and retired by Curriculum Specialist
    Given I have an active course with 914 created for modify
    When I submit a retire course proposal with all fields complete as Faculty
    And I approve the retire course proposal as Department Approver
    And I blanket approve the retire course proposal as Curriculum Specialist
    Then the retire course proposal is successfully approved
    And the course status is retired

  Scenario: RC2.1 Verify Curriculum Specialist can create an Admin Retire Proposal and Approve and Retire
    Given I have an active course with 915 created for modify
    When I create a administrative retire as Curriculum Specialist
    Then I can approve and retire the admin retire proposal
    And the course is retired

  Scenario: RC2.2 Verify Curriculum Specialist cannot create an admin retire proposal when a retire proposal is already in progress
    Given I have an active course with 916 created for modify
    And there is a retire course proposal created as Curriculum Specialist
    When I attempt to create a second admin retire proposal
    Then I do not have the option to retire the course

  Scenario: RC2.3 Verify Curriculum Specialist can create retire course proposal
    Given I have an active course with 917 created for modify
    When there is a retire course proposal created as Curriculum Specialist
    Then I can review the retire course proposal details and submit
    And I approve the retire course proposal as Department Approver
    And I blanket approve the retire course proposal as Curriculum Specialist
    Then the retire course proposal is successfully approved
    And the course status is retired



