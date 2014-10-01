@nightly @blue_team
Feature: REG.Manage Hold Issue
  Hold 1.5 As an admin I want to be able to edit a Hold in the catalog

  Background:
    Given I am logged in as admin

#KSENROLL-14530
  Scenario: HOLD1.5.1 Verify that a hold updates after editing the hold code and organization
    When I search for a hold with a valid hold code
    And I edit that hold by adding an owning organization
    Then the hold is displayed in the catalog with the updated organization