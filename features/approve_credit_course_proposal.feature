@draft
Feature: Approve Course Proposal

  Scenario: RP2.1 Partial create a course proposal as Faculty and verify that Reviewer cannot Approve
    Given I have a course proposal with approve fields partially completed created as Faculty
    When I am logged in as Reviewer
    And I attempt to approve the course proposal
    Then I cannot approve the incomplete proposal

  Scenario: RP2.2 Create a course proposal with approve fields as Faculty and verify reviewer can approve
    Given I have a course proposal with approve fields created as Faculty
    When I am logged in as Reviewer
    And I attempt to approve the course proposal
    Then I can successfully approve the course proposal.

  Scenario: RP2.3 Partial create a course proposal as Faculty, complete proposal and approve as reviewer.
    Given I have a partially completed course proposal created as Faculty
    When I am logged in as Reviewer
    And I complete the missing fields on the proposal
    And I attempt to approve the course proposal
    Then I can successfully approve the course proposal