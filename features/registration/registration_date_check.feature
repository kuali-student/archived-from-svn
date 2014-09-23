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

    # For the following six scenarios, we use students who have been pre-configured with particular system dates
    #   which fall in different time periods relative to the early registration period for the term
    #   and to each student's individual registration appointment period, if they have one.

  #KSENROLL-14904
  Scenario: CR 30.1 Student with appointment and with system date prior to early reg period - reg from cart - registration should fail
    When I log in to student registration as A.TIMOTHYG
    And I attempt to register for a course in Fall 2012
    Then there is a message indicating that registration appointment period for TIMOTHYG has not begun

  #KSENROLL-14904
  Scenario: CR 30.1 Student with appointment and with system date prior to early reg period - reg from course search - registration should fail
    Given I am using a large screen size
    When I log in to student registration as A.TIMOTHYG
    When I search for a course in Fall 2012 and select a registration group
    And I register directly for the registration group
    Then there is a message indicating that registration appointment period for TIMOTHYG has not begun

  #KSENROLL-14904
  Scenario: CR 30.1 Student with appointment and with system date within early reg period but prior to appointment date - reg from cart - registration should fail
    When I log in to student registration as A.TOBIASJ
    And I attempt to register for a course in Fall 2012
    Then there is a message indicating that registration appointment period for TOBIASJ has not begun

  #KSENROLL-14904
  Scenario: CR 30.1 Student with appointment and with system date within appointment period - reg from cart - registration should succeed
    When I log in to student registration as A.TRAVISC
    And I attempt to register for a course in Fall 2012
    Then there is a message indicating successful registration

  #KSENROLL-14904
  Scenario: CR 30.1 Student without appointment and with system date within early reg period - reg from cart - registration should fail
    When I log in to student registration as A.TERRYM
    And I attempt to register for a course in Fall 2012
    Then there is a message indicating that no registration appointment has been scheduled

  #KSENROLL-14904
  Scenario: CR 30.1 Student without appointment and with system date within open reg period - reg from cart - registration should succeed
    When I log in to student registration as A.SUSANH
    And I attempt to register for a course in Fall 2012
    Then there is a message indicating successful registration
