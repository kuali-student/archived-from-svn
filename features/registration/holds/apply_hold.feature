@nightly @blue_team
Feature: REG.Apply Hold
  Hold2.3 As a Holds Functionary I want to apply hold
  Hold2.4 As a Holds Functionary I want to Date validations on apply hold
  Hold2.5 As a Holds Functionary I want to identify hold to apply

  Background:
    Given I am logged in as admin

#KSENROLL-14588
  Scenario: HOLD2.3.1 Verify that hold is applied to student
    When I apply a hold to student by completing the required information
    Then the hold exists for the student with an effective date

#KSENROLL-14590
  @draft
  Scenario: HOLD2.4.1.1 Verify that a hold is not applied to a student with an effective term before the first applied term
    Given there exists a term based hold issue
    When I attempt to apply the hold, with an effective term before the first applied term, to a student
    Then an effective term error message is displayed stating "Effective Term: Applied effective term should not be earlier than hold issue's first Term:"

  @draft
  Scenario: HOLD2.4.1.2 Verify that a hold is not applied to a student with an effective term after the last applied term
    Given there exists a term based hold issue
    When I attempt to apply the hold, with an effective term after the last applied term, to a student
    Then an invalid effective term message is displayed stating "Effective Term: Applied effective term should not be later than hold issue's last Term:"

  @draft
  Scenario: HOLD2.4.1.3 Verify that the effective term entered exists as an official ATP, when attempting to apply the hold
    Given there exists a term based hold issue
    When I attempt to apply the hold, with an invalid effective term, to a student
    Then an invalid term error message is displayed stating "Effective Term: No term defined for code:"

  @draft
  Scenario: HOLD2.4.2.1 Verify that a hold is not applied to a student with an effective date before the first applied date
    Given there exists a hold with a last applied date
    When I attempt to apply the hold, with an effective date before the first applied date, to a student
    Then an effective date error message is displayed stating "Effective Date: Applied effective date should not be earlier than hold issue's first application date:"

  @draft
  Scenario: HOLD2.4.2.2 Verify that a hold is not applied to a student with an effective date after the last applied date
    Given there exists a hold with a last applied date
    When I attempt to apply the hold, with an effective date after the last applied date, to a student
    Then an invalid effective date message is displayed stating "Effective Date: Has invalid date range"

  @draft
  Scenario: HOLD2.4.3 Verify that the end term of the applied hold defaults to the last applied term of the created hold.
    Given there exists a term based hold issue
    When I apply the hold to a student
    Then the end term defaults to the last applied term

  @draft
  Scenario: HOLD2.4.4 Verify that the end date of the applied hold defaults to the last applied date of the created hold.
    Given there exists a hold with a last applied date
    When I apply the hold to a student
    Then the end date defaults to the last applied date

#KSENROLL-14588\KSENROLL-14592
  Scenario: HOLD2.3.2\HOLD2.5.1 Verify that a term based hold is applied to student
    When I apply a term based hold to student by completing the required information
    Then the hold exists for the student with an effective start term
