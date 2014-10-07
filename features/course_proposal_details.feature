@nightly
Feature: GT.Course Proposal Details

  Scenario: CC11.1 Add cross list, joint offer, version code details to a Course Proposal
    Given I am logged in as Faculty
    When I create a basic course proposal with alternate identifier details
    And I perform a full search for the course proposal
    Then I should see alternate identifier details on the course proposal

  Scenario: CC11.2 Edit Alternate Identifier details on a Course Proposal
    Given I am logged in as Curriculum Specialist
    And I have a basic course proposal with alternate identifier details
    When I update Alternate Identifier details on the course proposal
    And I perform a full search for the course proposal
    Then I should see updated alternate identifier details on the course proposal

  Scenario: CC11.3 Delete alternate identifier details on a Course Proposal
    Given I am logged in as Faculty
    And I have a basic course proposal with alternate identifier details
    When I delete alternate identifier details to the course proposal
    And I perform a full search for the course proposal
    Then I should no longer see alternate identifier details on the course proposal


  Scenario: CC10.1 Add instructor, admin org, optional logistics, term and financial details (Optional-Other) to a Course Proposal
    Given I am logged in as Faculty
    When I create a course proposal with Optional-Other fields
    And I perform a full search for the course proposal
    Then I should see Optional-Other details on the course proposal

  Scenario: CC10.2 Edit Optional-Other details on a course proposal
    Given I am logged in as Curriculum Specialist
    And I have a basic course proposal created with Optional-Other fields
    When I update the Optional Other details on the course proposal
    And I perform a full search for the course proposal
    Then I should see updated Optional Other details on the course proposal

  Scenario: CC10.3 Delete Optional-Other details on a course proposal
    Given I am logged in as Faculty
    And I have a basic course proposal created with Optional-Other fields
    When I delete Optional-Other details on the course proposal
    And I perform a full search for the course proposal
    Then I should no longer see Optional-Other details on the course proposal

  Scenario: CC15.1 Add Supporting Documents to a Course Proposal
    Given I am logged in as Faculty
    When I create a basic course proposal with Supporting Documents
    And I perform a full search for the course proposal
    Then I should see Supporting Documents details on the course proposal

  Scenario: CC15.2 Edit Supporting Documents on a course proposal
    Given I am logged in as Faculty
    And I have a basic course proposal with Supporting Documents
    When I update the Supporting Documents on the course proposal
    And I perform a full search for the course proposal
    Then I should see updated Supporting Documents details on the course proposal

  Scenario: CC15.3 Delete Supporting Documents from a course proposal
    Given I am logged in as Faculty
    And I have a basic course proposal with Supporting Documents
    When I delete the Supporting Documents on the course proposal
    And I perform a full search for the course proposal
    Then I should no longer see Supporting Documents on the course proposal