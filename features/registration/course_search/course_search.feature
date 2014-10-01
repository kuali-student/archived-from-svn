@nightly @red_team

Feature: REG.Course Search
  CR 19.2 - As a student I want to search for courses so that I can view
            courses to potentially add them to my Reg Cart (Large format)
  CR 19.4 - As a student I want to select a course so that I can view its details (Large format)
  CR 19.6 - As a student I want to select a valid registration group from my search results so that
            I can add to my cart (large format)
  CR 19.8 - As a student I want to add a valid registration group to my registration cart
            from my search results (large format)
  CR 19.14  As a student I want to know if my selection is already in my
            registration cart so that I do not have duplicate entries (large format)
  Background:
    Given I am using a large screen size
    Given I am logged in as a Student

  #KSENROLL-13740 (all CR 19.2.x scenarios)
  Scenario Outline: CR 19.2.1 Search by Single Course Code
    When I search for a course with "<text>" text option
    Then courses containing "<expected>" course code appear
  Examples:
    | text     | expected |
    | ENGL202  | ENGL202  |
    | BSCI120  | BSCI120  |

  Scenario Outline: CR 19.2.2 Search by Multiple Course Code
    When I search for a course with "<text>" text option
    Then courses containing "<expected>" course codes appear
  Examples:
    | text                    | expected                                                                     |
    | ENGL101 CHEM231         | ENGL101, ENGL101A, ENGL101C, ENGL101H, ENGL101M, ENGL101S, ENGL101X, CHEM231 |
    | PHYS374 CHEM231         | PHYS374, CHEM231                                                             |
    | ENGL202 BSCI120 ENGL206 | ENGL202, BSCI120, ENGL206                                                    |

  Scenario Outline: CR 19.2.3 Search by Subject Code
    When I search for a course with "<text>" text option
    Then courses containing "<expected>" course codes appear
  Examples:
    | text     | expected         |
    | ENGL     | ENGL, HIST, WMST |
    | BSCI     | BSCI             |

  Scenario Outline: CR 19.2.4 Search by Multiple Subject Code
    When I search for a course with "<text>" text option
    Then courses containing "<expected>" course codes appear
  Examples:
    | text       | expected                     |
    | ENGL BSCI  | ENGL, BSCI                   |
    | CHEM HIST  | CHEM, HIST, BSCI, ENGL, WMST |

  Scenario Outline: CR 19.2.9 Search by Keyword
    When I search for a course with "<text>" text option
    Then courses containing "<expected>" course codes appear
  Examples:
    | text    | expected                                                                 |
    | Atomic  | PHYS721, CHEM682, PHYS420, CHEM403, PHYS622, PHYS728                     |
    | Microb  | BSCI122, BSCI222, BSCI223, BSCI283, BSCI348A, BSCI348R, BSCI424, BSCI443 |

  #KSENROLL-13899, KSENROLL-13900, KSENROLL-13901
  Scenario: CR 19.4 - As a student I want to select a course so that I can view its details
            CR 19.6 - As a student I want to select a valid registration group from my search results
            CR 19.8 - As a student I want to add a valid registration group to my registration cart
    When I search for a course with "BSCI330" text option
    Then courses containing "BSCI330" course code appear
    And I can view the details of the BSCI330 course
    When I select a lecture and lab
    Then I should see only the selected lecture and lab
    When I add the selected lecture and lab to my registration cart
    Then I can see the selected section has been added to my cart
    * I remove the course from my registration cart on the search page
    * I log out from student registration large format

    #KSENROLL-14021
  Scenario: CR 19.14 - Student is notified that course search selection is already in registration cart
    Given I have added a CHEM course to my registration cart
    When I search for the same course
    And I select the same lecture and discussion as in the course
    Then the Add to Cart option should change to a notice that the course is in my cart
    * I remove the course from my registration cart on the search page
    * I log out from student registration large format

    #KSENROLL-14808
  Scenario: CR 0.4 - Register for course directly from search
    When I search for a WMST course and select a registration group
    And I register directly for the registration group
    Then there is a message indicating successful direct registration
    And the course is in my schedule

#KSENROLL-14809
  Scenario: CR 0.5 - Waitlist a course directly from search
    When I search for a BSCI course and select a registration group
    And I waitlist directly for the registration group
    Then there is a message indicating successful direct addition to waitlist
    And the course is waitlisted in my schedule
