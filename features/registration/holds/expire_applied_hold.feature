@nightly @blue_team
Feature: REG.Expire Applied Hold
  Hold2.6 As a Holds Functionary I want to manually expire an applied hold on the specified student so that it's no longer enforced
  Hold 2.14 As a Holds Functionary I want the system not to display expired holds if the maintain history is set to false

  Background:
    Given I am logged in as admin

#KSENROLL-14594
  Scenario: HOLD2.6.1 Verify that a term based applied hold can't be expired if the expiration term is before the effective term
    Given there exists a term based hold issue
    And I apply the hold to a student
    When I attempt to expire the hold with an expiration term earlier than the effective term
    Then an expiration term error message is displayed stating "Applied expiration term should not be earlier than hold issue's last Term:"

  Scenario: HOLD2.6.2 Verify that a term based applied hold can be expired if the expiration term is after the effective term
    Given there exists a term based hold issue
    And I apply the hold to a student
    When I expire the hold with an expiration term that is after the effective term
    Then the hold is no longer displayed for the student

  Scenario: HOLD2.6.3 Verify that an applied hold can't be expired if the expiration date is earlier than the effective date
    Given there exists a hold issue
    And I apply the hold to a student
    When I attempt to expire the hold with an expiration date earlier than the effective date
    Then an invalid date range error message is displayed

  Scenario: HOLD2.6.4 Verify that an applied hold can be expired if the expiration date is later than the effective date
    Given there exists a hold issue
    And I apply the hold to a student
    When I expire the hold with an expiration date that is later than the effective date
    Then the hold is no longer displayed for the student

#KSENROLL-14604
  Scenario: HOLD2.14.1 Verify that an expired hold, that's not set to maintain history, doesn't display for a student
    Given there exists a hold that does not maintain history
    And I apply the hold to a student
    When I expire that hold
    Then the hold is no longer displayed for the student

  Scenario: HOLD2.14.2 Verify that an expired hold, that's set to maintain history, displays for a student
    Given there exists a hold that maintains history
    And I apply the hold to a student
    When I expire that hold
    Then the expired hold is displayed for the student