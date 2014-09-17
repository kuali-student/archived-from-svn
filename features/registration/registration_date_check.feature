@nightly @red_team

Feature: REG.Registration Date Check

  CR 12.1 - As an admin I want to allow students to add courses to their cart before registration begins
            so they can prepare their transactions

  CR 12.2 - As an admin, I want students to have the ability to perform registration transactions
            on courses whose deadlines are different from the standard term

  CR 16.1 and CR 17.1 - As an admin I want to prevent a student from accessing the registration functions
                        for a term because registration isn’t open
  CR 30.1 - As an administrator I want to prevent a student from registering for courses prior to their registration appointment

  Background:
    Given I am using a mobile screen size

#KSENROLL-13255
  Scenario: CR 12.1 Verify pre-registration period allows access to cart but not registration
    Given I log in to student registration as E.SONALIK
    When I attempt to display my registration cart during pre-registration
    Then I can add and remove courses from my cart
    When I attempt to register for the course
    Then there is a message indicating that the registration period is not open yet

  #KSENROLL-13256
  Scenario: CR 12.2 Verify registration for courses in sub-terms with different reg periods
    Given I log in to student registration as E.STEVENJ
    And I attempt to register for a course in a subterm whose registration period is closed
    Then there is a message indicating that the registration period is over
    When I attempt to register for a course in a subterm whose registration period is open
    Then there is a message indicating successful registration

  #KSENROLL-13257
  Scenario: CR 16.1/CR 17.1 Verify unable to access Reg Cart for a term whose registration period is not open
    When I log in to student registration as a user configured for Fall 2011
    And I attempt to access registration for Fall 2012
    Then there is a message indicating that registration is unavailable for the term
    When I log in to student registration as a user configured for Fall 2012
    And I attempt to access registration for Fall 2012
    Then I am able to access registration features

  #KSENROLL-14904
  Scenario: CR 30.1 Student with appointment with system date prior to early reg period - reg from cart
    When I log in to student registration as A.TIMOTHYG
    And I attempt to register for a course in Fall 2012
    Then there is a message indicating that my registration appointment period has not begun

  #KSENROLL-14904
  Scenario: CR 30.1 Student with appointment with system date prior to early reg period - reg from course search
    Given I am using a large screen size
    When I log in to student registration as A.TIMOTHYG
    When I search for a course in Fall 2012 and select a registration group
    And I register directly for the registration group
    Then there is a message indicating that my registration appointment period has not begun
