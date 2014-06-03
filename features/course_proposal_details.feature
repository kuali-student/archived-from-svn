@draft
Feature: Add details to a course proposal

  Scenario: CC5.1 Add cross list, joint offer, version code details to a Course Proposal
    Given I am logged in as Faculty
    When I create a basic proposal with alternate identifier details
    And I perform a full search for the course proposal
    Then I should see alternate identifier details on the course proposal


  Scenario: CC5.2 Edit Alternate Identifier details on a Course Proposal
    Given I am logged in as Curriculum Specialist
    And I have a basic course proposal with alternate identifier details
    When I update Alternate Identifier details on the course proposal
    And I perform a full search for the course proposal
    Then I should see updated alternate identifier details on the course proposal

  Scenario: CC5.3 Delete alternate identifier details on a Course Proposal
    Given I am logged in as Faculty
    And I have a basic course proposal with alternate identifier details
    When I delete alternate identifier details to the course proposal
    And I perform a full search for the course proposal
    Then I should see alternate identifier details on the course proposal

  Scenario: CC6.1 Add instructor, admin org, optional logistics, term and financial details (Optional-Other) to a Course Proposal
    Given I have a basic course proposal created as Faculty
    When I add Optional-Other details to the course proposal
    And I perform a search for the course proposal
    Then I should see Optional-Other details on the course proposal
  Scenario: CC6.2 Edit Optional-Other details on a course proposal
    Given I have a basic course admin proposal with Optional-Other details created as CS
    When I update Optional-Other details on the course proposal
    And I perform a search for the course proposal
    Then I should see Optional-Other details on the course proposal
  Scenario: CC6.3 Delete Optional-Other details on a course proposal
    Given I have a basic course proposal with Optional-Other details created as Faculty
    When I delete Optional-Other details on the course proposal
    And I perform a search for the course proposal
    Then I should see Optional-Other details on the course proposal