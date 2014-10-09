@nightly
Feature: Add note to terms

  Background:
    Given I am logged in as a Student

  Scenario: NP 1.0.1 Verify that I can add a note to term
    When I add a note to term
    Then the term note should be successfully added

  Scenario: NP 2.0.1 Verify that I can edit the term note
    Given I have a term with notes
    When I edit the term note
    Then the term note should be successfully edited

  Scenario: NP 2.0.2 Verify that I can delete the term note
    Given I have a term with notes
    When I delete the term note
    Then the term note should be deleted from the term