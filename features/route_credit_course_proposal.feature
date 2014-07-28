@draft
Feature: GT.Route Credit Course Proposal

  Scenario: RP1.1 Create a course proposal with required for submit fields and submit as Faculty
    Given I am logged in as Faculty
    When I complete the required for submit fields on the course proposal
    Then I submit the course proposal
    And I perform a full search for the course proposal
    Then I can see updated status of the course proposal

  Scenario: RP1.2 Create a course proposal with required for submit fields and submit as CS
    Given I am logged in as Curriculum Specialist
    When I complete the required for submit fields on the credit course proposal
    Then I submit the course proposal
    And I perform a full search for the course proposal
    Then I can see updated status of the course proposal

  Scenario: RP1.3 Create a course proposal without all the required for submit fields and submit
    Given I am logged in as Faculty
    When I do not complete all the required for submit fields on the course proposal
    When I submit the incomplete course proposal
    Then the status of course proposal has not changed

  Scenario: RP1.4 Partially create a course proposal as Faculty and complete proposal and submit as CS
    Given I have a partially completed course proposal created as Faculty
    When I enter remaining fields on the partially created course proposal as Curriculum Specialist
    Then I submit the course proposal
    And I perform a full search for the course proposal
    Then I can see updated status of the course proposal
