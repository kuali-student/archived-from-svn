@nightly @red_team

Feature: REG.Course Search Mobile
  CR 19.1 - As a student I want to search for courses so that I can view
            courses to potentially add them to my Reg Cart (mobile format)
  CR 19.3 - As a student I want to select a course so that I can view its details (mobile format)
  CR 19.5 - As a student I want to select a valid registration group from my search results so that
            I can add to my cart (mobile format)
  CR 19.7 - As a student I want to add a valid registration group to my registration cart
            from my search results (mobile format)
  CR 19.13  As a student I want to know if my selection is already in my
            registration cart so that I do not have duplicate entries (mobile format)
  Background:
    Given I am using a mobile screen size
    Given I am logged in as a Student

  #KSENROLL-14150 (all CR 19.1.x scenarios)
  Scenario Outline: CR 19.1.1 Search by Single Course Code
    When I search for a course with "<text>" text option
    Then "<expected>" course code appears
  Examples:
    | text     | expected |
    | ENGL202  | ENGL202  |
    | BSCI120  | BSCI120  |

  Scenario Outline: CR 19.1.2 Search by Multiple Course Code
    When I search for a course with "<text>" text option
    Then "<expected>" course codes appear
  Examples:
    | text                    | expected                                                                     |
    | ENGL101 CHEM231         | ENGL101, ENGL101A, ENGL101C, ENGL101H, ENGL101M, ENGL101S, ENGL101X, CHEM231 |
    | PHYS374 CHEM231         | PHYS374, CHEM231                                                             |
    | ENGL202 BSCI120 ENGL206 | ENGL202, BSCI120, ENGL206                                                    |

  Scenario Outline: CR 19.1.3 Search by Subject Code
    When I search for a course with "<text>" text option
    Then courses containing "<expected>" subject code appear
  Examples:
    | text     | expected         |
    | ENGL     | ENGL, HIST, WMST |
    | BSCI     | BSCI             |

  Scenario Outline: CR 19.1.4 Search by Multiple Subject Code
    When I search for a course with "<text>" text option
    Then courses containing "<expected>" subject codes appear
  Examples:
    | text       | expected                     |
    | ENGL BSCI  | ENGL, BSCI                   |
    | CHEM HIST  | CHEM, HIST, BSCI, ENGL, WMST |

  Scenario Outline: CR 19.1.9 Search by Keyword
    When I search for a course with "<text>" text option
    Then "<expected>" course codes appear
  Examples:
    | text    | expected                                                                 |
    | Atomic  | PHYS721, CHEM682, PHYS420, CHEM403, PHYS622, PHYS728                     |
    | Microb  | BSCI122, BSCI222, BSCI223, BSCI283, BSCI348A, BSCI348R, BSCI424, BSCI443 |

  #KSENROLL-14151, KSENROLL-14152, KSENROLL-14157
  Scenario: CR 19.3 - As a student I want to select a course so that I can view its details
            CR 19.5 - As a student I want to select a valid registration group from my search results
            CR 19.7 - As a student I want to add a valid registration group to my registration cart
    When I search for a course with "BSCI330" text option
    Then courses containing "BSCI330" course code appear
    And I can view the details of the BSCI330 course
    When I select a lecture and lab
    Then I should see only the selected lecture and lab
    When I add the selected lecture and lab to my registration cart
    Then I can see the selected section has been added to my cart
    * I remove the course from my registration cart on the search page
    * I log out from student registration

  #KSENROLL-14475
  Scenario Outline: CR 19.3 - Test functioning of tabs to view various aspects of AO details
    When I search for a course with "BSCI330" text option
    Then courses containing "BSCI330" course code appear
    And I can view the details of the BSCI330 course
    When I choose the <tab> tab for <ao_type>
    Then I see <expected> in the <tab> details for activity offering "<ao_code>"
  Examples:
    | tab       | ao_type | ao_code | expected                                      |
    | time      | Lecture | Y       | Tu 6:30-9:30pm                                |
    | instr     | Lecture | Y       | Terri Raymond                                 |
    | seatsLoc  | Lecture | Y       | PLS 1140 48/48                                |
    | all       | Lecture | Y       | Tu 6:30-9:30pm Terri Raymond PLS 1140 48/48   |

  #KSENROLL-14161
  Scenario: CR 19.13 - Student is notified that course search selection is already in registration cart
    Given I have added a CHEM course to my registration cart
    When I search for the same course
    And I select the same lecture and discussion as in the course
    Then the Add to Cart option should change to a notice that the course is in my cart
    * I remove the course from my registration cart on the search page
    * I log out from student registration
