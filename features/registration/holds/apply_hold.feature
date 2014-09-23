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

#KSENROLL-14588\KSENROLL-14592
  Scenario: HOLD2.3.2\HOLD2.5.1 Verify that a term based hold is applied to student
    When I apply a term based hold to student by completing the required information
    Then the hold exists for the student with an effective start term

#KSENROLL-14590
  @pending
  Scenario: HOLD2.4.1.1 Verify that a hold with an effective term before the first applied term is not applied to a student
    Given there exists a term based hold issue
    When I attempt to apply the hold where the effective term is before the first applied term
    Then an effective term error message is displayed

  @pending
  Scenario: HOLD2.4.1.2 Verify that a hold with an effective term after the last applied term is not applied to a student
    Given there exists a term based hold issue
    When I attempt to apply the hold where the effective term is after the last applied term
    Then an invalid effective term message is displayed

  @pending
  Scenario: HOLD2.4.1.3 Verify that the effective term entered exists as an official ATP, when attempting to apply the hold
    Given there exists a term based hold issue
    When I attempt to apply the hold using an invalid term
    Then an invalid term error message is displayed

  @pending
  Scenario: HOLD2.4.2.1 Verify that a hold with an effective date before the first applied date is not applied to a student
    Given there exists a hold with a last applied date
    When I attempt to apply the hold where the effective date is before the first applied date
    Then an effective date error message is displayed stating

  @pending
  Scenario: HOLD2.4.2.2 Verify that a hold with an effective date after the last applied date is not applied to a student
    Given there exists a hold with a last applied date
    When I attempt to apply the hold where the effective date is after the last applied date
    Then an invalid effective date range message is displayed

  @pending
  Scenario: HOLD2.4.3 Verify that the end term of the applied hold defaults to the last applied term of the created hold
    Given there exists a term based hold issue
    When I apply the hold to a student
    Then the end term defaults to the last applied term

  @pending
  Scenario: HOLD2.4.4 Verify that the end date of the applied hold defaults to the last applied date of the created hold
    Given there exists a hold with a last applied date
    When I apply the hold to a student
    Then the end date defaults to the last applied date

