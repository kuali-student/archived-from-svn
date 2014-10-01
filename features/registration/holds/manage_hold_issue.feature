@nightly @blue_team
Feature: REG.Manage Hold Issue
  Hold 1.4 As an admin I want to be able to search for a hold in the catalog

  Background:
    Given I am logged in as admin

#KSENROLL-14523
  Scenario: HOLD1.4.1 Verify that a specific hold displays when searching for that hold
    When I search for a hold issue
    Then a hold matching that code is displayed

  Scenario: HOLD1.4.2 Verify that no hold displays when searching for a hold that doesn't exist
    When I search for a hold that doesn't exist
    Then no search results are displayed