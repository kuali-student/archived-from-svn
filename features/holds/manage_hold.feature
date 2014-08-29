@nightly @blue_team
Feature: Holds.Manage Hold
  Hold 1.4 As an admin I want to be able to search for a hold in the catalog
  Hold 1.5 As an admin I want to be able to edit a Hold in the catalog

  Background:
    Given I am logged in as admin

  #KSENROLL-14523
  @Draft
  Scenario: Hold 1.4.1 Verify that a specific hold displays when searching for that hold in the catalog
    When I search for a hold with a valid hold name and description phrase
    Then a hold matching the name as well as the phrase is displayed

  @Draft
  Scenario: Hold 1.4.2 Verify that no hold displays when searching for a hold that doesn't exist in the catalog
    When I attempt to search for a hold that doesn't exist
    Then no search results are displayed