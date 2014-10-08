@nightly @blue_team
Feature: REG.Applied Holds on Admin Registration
  Holds 3.1 As Holds Functionary, when accessing registration for a term, I want to be informed if a student has a hold
            so that I know how to perform registration tasks
  Holds 3.2 As a Holds Functionary, while registering a student for classes, I want to be informed if a student has a
            hold so that I know how to perform registration tasks

  Background:
    Given I am logged in as admin

#KSENROLL-15158
  Scenario: HOLD3.1.1 Verify that a warning message appears when accessing registration for a student that has a registration hold
    When I have applied a registration hold to a student
    And I access registration for that student and term
    Then a message appears informing the user of a hold on the student

  Scenario: HOLD3.1.2 Verify that no warning message appears when accessing registration for a student that has a registration hold but for a different term
    When I have applied a registration hold to a student
    And I access registration for that student in a different term
    Then no message appears informing the user of a hold on the student

#KSENROLL-15159
  Scenario: HOLD3.2.1 Verify a warning message appears when registering a student with an applied hold
    Given I have applied a Hold Issue to a student
    When I register that student for a course
    Then a warning message appears indicating that the student has too many registration transactions in the term

  Scenario: HOLD3.2.2 Verify a warning message appears when registering a student with an applied hold
    Given I have applied a Hold Issue to a student
    When I register that student for a course in a different term
    Then no warning message about the student having too many registration transactions appears

  Scenario: HOLD3.2.3 Verify a warning message appears when registering a student with an applied hold
    Given I have applied a Hold Issue to a student
    When I edit a registered course for the student
    Then a warning message appears indicating that the student has too many registration transactions in the term

  Scenario: HOLD3.2.4 Verify a warning message appears when registering a student with an applied hold
    Given I have applied a Hold Issue to a student
    When I edit a registered course for the student which is in a different term
    Then no warning message about the student having too many registration transactions appears

  Scenario: HOLD3.2.5 Verify a warning message appears when registering a student with an applied hold
    Given I have applied a Hold Issue to a student
    When I drop a registered course for the student
    Then a warning message appears indicating that the student has too many registration transactions in the term

  Scenario: HOLD3.2.6 Verify a warning message appears when registering a student with an applied hold
    Given I have applied a Hold Issue to a student
    When I drop a registered course for the student which is in a different term
    Then no warning message about the student having too many registration transactions appears