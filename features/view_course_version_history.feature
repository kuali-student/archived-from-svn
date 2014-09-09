@nightly
Feature: GT.View Course Version History

  Background:

    Given I am logged in as Faculty

  Scenario: VH1.1 Version History Table displays details of all versions of a course
    When I view the version history of ENGL212
    Then I can see the details of the course versions

  Scenario: VH1.2 Verify all the features of the Version History Table displays
    When I view the version history of ENGL212
    Then I cannot select more than two versions
    And I cannot Show versions without any versions selected
    When I cancel out of the version history table
    Then I can view the current course version details after canceled out

  Scenario: VH1.3 Show single current version of course
    When I view the version history of HIST130
    Then I can view the current course version details

  Scenario: VH1.4 Show single non-current version of course
    When I view the version history of HIST130
    Then I can view the non-current course version details
    Then I can view the current course version details from the non-current course version

  Scenario: VH1.5 Show comparison view of two course versions
    When I view the version history of HIST130
    Then I can compare two sets of the version details
    And I can clearly see the data differences
