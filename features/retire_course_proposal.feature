@draft
Feature: GT.Proposal to retire a Course


Scenario: Verify that a proposal to retire and course can be submitted successfully
  Given I have an active course
  When I create a proposal to retire the course
  And review the proposal to retire the course
  Then I can review the fields on the proposal to retire
  And I should be able to successfully submit the proposal to retire
  And the proposal to retire is approved by Department Chair
  And the proposal to retire is blanket approved by Publication Chair
  And the course status is retired



