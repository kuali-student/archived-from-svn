@draft
Feature: GT.Find a Course

  Scenario: CC xx.1 Verify empty search string results in validation error
    Given I am logged in as Faculty
    When I perform a blank course code search
    Then I get a course code required validation error

  Scenario: CC xx.2 Verify partial search string on Course code returns correct results
    Given I am logged in as Curriculum Specialist
    When I search for a course code with partial search string
    Then I get the results matching the search criteria

  Scenario: CC xx.3 Verify full search string on Course Code returns correct results
    Given I am logged in as Faculty
    When I search for a Course Code with complete search string
    Then I get correct course returned on the search

  Scenario: CC xx.4 Verify that no matching results message is displayed
    Given I am logged in as Curriculum Specialist
    When I search for a course code by an invalid search term
    Then a message indicating no matching records is displayed.




