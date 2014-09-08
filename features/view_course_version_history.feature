@nightly
Feature: GT.View Course Version History

  Background:

    Given I am logged in as Faculty

  Scenario: VH1.1 Version History Table displays details of all versions of a course
    Given I find a course ENGL212 with versions
    When I view the version history
    Then I can see the details of the course versions

  Scenario: VH1.2 Version History Table displays details of all versions of a course
    Given I find a course ENGL212 with versions
    When I view the version history
    Then I cannot select more than two versions
    And I cannot Show versions without any versions selected
    When I cancel out of the version history table
    Then I can view the current course version details

  Scenario: VH1.3 Show single current version of course
    Given I find a course HIST130 with versions
    When I select a single current version
    Then I can view the current course version details

  Scenario: VH1.4 Show single non-current version of course
    Given I find a course HIST130 with versions
    When I select a single non-current version
    Then I can view the non-current course version details
    When I select to view the current version
    Then I can view the current course version details

  Scenario: VH1.5 Show comparison view of two course versions
    Given I find a course HIST130 with versions
    When I select two versions of a course
    Then I can view both sets of the version details
    And I can clearly see the data differences