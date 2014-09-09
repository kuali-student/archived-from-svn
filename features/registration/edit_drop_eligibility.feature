@nightly @red_team

Feature: REG.Edit Drop Eligibility
  CR 28.1 - As an administrator, I want the system to prevent a student from exceeding the
            term maximum credit limit when they edit a course so they do not violate institutional policy
  CR 28.2 - As an administrator, I want the system to ensure students can only edit student reg options
            during specific time periods so they do not violate institutional policy
  CR 28.3 - As an administrator, I want the system to ensure students can only edit a registrations
            credits during specific time periods so they do not violate institutional policy
  CR 28.4 - As an administrator, I want the system to ensure students can only drop courses during
            specific time periods so they do not violate institutional policy


#KSENROLL-14637
  Scenario: CR 28.1 Ensure students cannot edit a course such that their credit limit for the term is exceeded.
    Given I am registered for courses in a fall term
    When I attempt to edit the credits for one of the courses so my credit total exceeds the term credit limit
    Then there is a message indicating that the course edit failed due to the credit limit
    And the course credits are unchanged

#KSENROLL-14638/39
  Scenario: CR 28.2/CR 28.3 Prevent student from editing a course when outside of the course edit period.
    Given I am registered for a course and it is after the edit period has passed
    When I attempt to edit the grading method for the course
    Then there is a message indicating that the course edit failed due to the timing of the edit
    When I attempt to edit the credits for the course
    Then there is a message indicating that the course edit failed due to the timing of the edit
    And the course options are unchanged

#KSENROLL-14640
  Scenario: CR 28.4 Prevent student from dropping a course when outside of the course drop period.
    Given I am registered for a course and it is after the drop period has passed
    When I attempt to drop the course
    Then there is a message indicating that the course drop failed
    And the course is still in my schedule

