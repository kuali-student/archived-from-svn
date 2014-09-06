@wip
Feature: BT.Add to plan view

  Background:

    Given I am logged in as a student with privelege

  Scenario:  Academic Year per Planner Page
    When I navigate to planner page
    Then the relavent features of the page should be displayed


  Scenario:  View More Details Link
    When I bookmark a course
    Then I should be able to see the View more details link in the bookmark section

    Scenario: Verify that credit tally should exist on the credit line
      When I navigate to planner page
      Then the credit tally should exist on the credit line

