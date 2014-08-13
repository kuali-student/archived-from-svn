@nightly
Feature: GT.Course Proposal Details_Requisites

  Scenario: CC13.1 Add a single and 0 variable Eligibility requisite to a Course Proposal
    When I create a basic course proposal with two basic Eligibility requisites
    And I perform a full search for the course proposal
    Then I should see the the basic Eligibility requisites on the course proposal

  Scenario: CC13.2 Add multiple variable requisite to a Course Proposal
    When I create a basic course proposal with Recommended Preparation rule with multiple variables including course set
    And I perform a full search for the course proposal
    Then I should see the multiple variable requisite on the course proposal

  Scenario: CC13.3 Edit requisites on a Course Proposal
    Given have a basic course proposal with requisite details
    When I update the requisite details on the course proposal
    And I perform a full search for the course proposal
    Then I should see updated requisite details on the course proposal

  Scenario: CC13.4 Delete with requisite details from a course proposal
    Given have a basic course proposal with requisite details
    When I delete the requisite details on the course proposal
    And I perform a full search for the course proposal
    Then I should no longer see with requisite details on the course proposal