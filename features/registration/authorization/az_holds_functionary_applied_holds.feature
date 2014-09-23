@blue_team
Feature: REG.Holds Functionary using Applied Holds
  Hold2.8 As a Holds Functionary I want to be the appropriate Role to expire an applied hold
  Hold2.9 As a Holds Functionary I want to be the appropriate Role to delete an applied hold
  Hold2.10 As a Holds Functionary I want to be the appropriate Role to apply a hold to a student

#KSENROLL-14598
  @pending
  Scenario: HOLD2.8.1 Validate that a Holds Functionary can expire an applied hold
    Given I am logged in as a Holds Functionary
    And I apply a hold for expiration to a student
    When I expire the hold with an expiration date that is later than the effective date
    Then the expired hold is no longer displayed for the student

  @pending
  Scenario: Hold2.8.2 Validate that a non Holds Functionary can not expire an applied hold
    Given I am logged in as a Schedule Coordinator
    And I find a hold
    When I attempt to expire that hold
    Then an expire hold authorization error message is displayed

#KSENROLL-14600
  @pending
  Scenario: HOLD2.9.1 Validate that a Holds Functionary can delete an applied hold
    Given I am logged in as a Holds Functionary
    And I apply a hold for deletion to a student
    When I delete that hold
    Then the deleted hold no longer displays for the student

  @pending
  Scenario: Hold2.9.2 Validate that a non Holds Functionary can not delete an applied hold
    Given I am logged in as a Schedule Coordinator
    And I find a hold
    When I attempt to delete that hold
    Then a delete hold authorization error message is displayed

#KSENROLL-14602
  @pending
  Scenario: HOLD2.10.1 Validate that a Holds Functionary can apply a hold to a student
    Given I am logged in as a Holds Functionary
    When I apply a hold to student by completing the required information
    Then the hold exists for the student with an effective date

  @pending
  Scenario: Hold2.10.2 Validate that a non Holds Functionary can not apply a hold to a student
    Given I am logged in as a Schedule Coordinator
    When I apply a hold to student by completing the required information
    Then an apply hold authorization error message is displayed