@draft
Feature: Approve Course Proposal

  Scenario Outline: RP2.1 Partial create a course proposal as Faculty and verify that Reviewer cannot Approve
    Given I have a course proposal with approve fields partially completed created as <author>
    When I am logged in as a <reviewer>
    And I attempt to approve the course proposal
    Then I cannot approve the incomplete proposal
    Examples:
      |author|reviewer|
      |fred  |martha  |
      |alice |martha  |


  Scenario Outline: RP2.2 Create a course proposal with approve fields as Faculty and verify reviewer can approve
    Given I have a course proposal with approve fields created as <author>
    When I am logged in as a <reviewer>
    And I approve the course proposal
    Then I can successfully approve the course proposal
    Examples:
      |author|reviewer|
      |fred  |martha  |
      |alice |martha  |

  Scenario Outline: RP2.3 Partial create a course proposal as Faculty, complete proposal and approve as reviewer.
    Given I have a partial completed course proposal created as <author>
    When I am logged in as a <reviewer>
    And I complete the missing fields on the proposal
    And I approve the completed course proposal
    Then I can successfully approve the course proposal
    Examples:
      |author|reviewer|
      |fred  |martha  |
      |alice |martha  |