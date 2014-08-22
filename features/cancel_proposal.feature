@draft
Feature: GT.Cancel Proposal

#Cancel Course - KSCM-1507
Scenario: CP1.1 Faculty can cancel a proposal while it is draft
    Given I am logged in as Faculty
    And I have a basic credit course proposal created
    When I Cancel Proposal
    Then can see the proposal has been cancelled

#Cancel Course - KSCM-1507
  Scenario: CP1.2 No option to cancel a proposal once it is enroute
    When I have a credit course proposal submitted as Faculty
    Then I cannot cancel the proposal

#Withdraw  KSCM-2607
Scenario: CP2.1 Faculty can withdraw a proposal while it is Enroute
  Given I have a proposal submitted as Faculty
  When I Withdraw the Proposal
  Then can see the proposal has been Withdrawn

#Withdraw  KSCM-2607
Scenario Outline: CP2.2 No option to withdraw a proposal once it is Approved
  Given I have a course proposal Blanket Approved by <curriculum_specialist>
  Then I cannot cancel the proposal as <faculty>
    Examples:
  |curriculum_specialist|faculty|
  |alice                |fred   |