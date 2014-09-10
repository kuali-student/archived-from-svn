@nightly @blue_team
Feature: REG.Create Hold
  Hold 1.1 As an admin I want to create the general information for a hold so that the hold can be added to the catalog of holds
  Hold 1.2 As an admin I want to add which Organizations can apply and expire a hold in the catalog so that only those
           people in those Organizations have access to apply and expire the hold

  Background:
    Given I am logged in as admin

#KSENROLL-14522
  Scenario: HOLD1.1.1 Verify that a hold is created and added to the catalog of holds
    When I create a hold by completing the required information needed
    Then the hold exists in the hold catalog

  Scenario: HOLD1.1.2 Verify that a duplicate check message is displayed when creating a duplicate hold entry
    When I attempt to create a duplicate hold entry
    Then a duplicate check message is displayed

#KSENROLL-14526
  Scenario: HOLD1.2.1 Verify that a hold is created and added to the catalog of holds after adding an organization for apply and another for expire
    When I create a hold with authorizing organization for apply as well as expire
    Then the hold is displayed in the catalog with the created authorizations

  Scenario: HOLD1.2.2 Verify that authorizing organization permission message is displayed after adding authorizing organization without apply and expire permission
    When I create a hold with authorizing organization without apply and expire permission
    Then a permission error message is displayed