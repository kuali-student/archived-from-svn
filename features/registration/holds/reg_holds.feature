@nightly @red_team

Feature: REG.Registration Holds

  CR 3.5 - As an administrator, I want the system to stop the student’s access
           to the term if there are active holds so that students cannot perform
           registration functions
  CR 3.6 - As a administrator, I want the system to prevent the student from performing
           registration transactions if there are holds on her record so that holds are
           not violated

  Background:
    Given I am using a mobile screen size

  #KSENROLL-15183
  Scenario: CR 3.5 - student is unable to access registration because of holds
    Given I log in to student registration as A.JAYR
    And I attempt to access registration for Fall 2012
    Then there is a message indicating that registration is unavailable for the term
    And there is a message indicating I have a mandatory advising hold

  #KSENROLL-15184 - CR 3.6 - 5 scenarios

  Scenario: 1 - student is unable to register for a course because of holds
    Given I log in to student registration as A.JANED
    And I attempt to register for a course in Fall 2012
    Then there is a message in my cart indicating that I have too many registration transactions

  Scenario: 2 - student is unable to edit a registered course because of holds
    Given I log in to student registration as A.JANED
    And I am registered for a course with variable credit and grading options
    And I go to my schedule
    And I edit the course in my schedule
    Then there is a message on my schedule indicating that I have too many registration transactions

  Scenario: 3 - student is unable to edit a waitlisted course because of holds
    Given I log in to student registration as A.JANED
    And I am waitlisted for a course with variable credit and grading options
    And I go to my schedule
    And I edit the course in my waitlist
    Then there is a message on my waitlist indicating that I have too many registration transactions

  Scenario: 4 - student is unable to drop a registered course because of holds
    Given I log in to student registration as A.JANED
    And I am registered for a course with variable credit and grading options
    And I go to my schedule
    And I remove the course from my schedule
    Then there is a message on my schedule indicating that I have too many registration transactions

  Scenario: 5 - student is unable to drop a waitlisted course because of holds
    Given I log in to student registration as A.JANED
    And I am waitlisted for a course with variable credit and grading options
    And I go to my schedule
    And I remove myself from the waitlist
    Then there is a message on my waitlist indicating that I have too many registration transactions
