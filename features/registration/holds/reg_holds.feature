@nightly @red_team

Feature: REG.Registration Holds

  CR 3.5 - As an administrator, I want the system to stop the student’s access
           to the term if there are active holds so that students cannot perform
           registration functions

  Background:
    Given I am using a mobile screen size

  #KSENROLL-15134
  @wip
  Scenario: CR 3.5 - student is unable to access registration because of holds
    Given I log in to student registration as A.JAYR
    And I attempt to access registration for Fall 2012
    Then there is a message indicating that registration is unavailable for the term
    And there is a message indicating I have a mandatory advising hold
