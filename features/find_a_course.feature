@nightly
Feature: GT.Find a Course

  Scenario: FC1.1 Verify empty search string results in validation error
    Given I am logged in as Faculty
    When I perform a blank search for Courses
    Then I get a course code required validation error

  Scenario: FC1.2 Verify partial search string on Course code returns correct results
    Given I am logged in as Curriculum Specialist
    When I search for Courses by entering partial course code
    Then I get the results matching the search criteria

  Scenario: FC1.3 Verify full search string on Course Code returns correct results
    Given I am logged in as Faculty
    When I search for Courses by entering complete course code
    Then I get correct course returned on the search

  Scenario: FC1.4 Verify that no matching results message is displayed
    Given I am logged in as Curriculum Specialist
    When I perform an invalid search for Courses
    Then a message indicating no matching records is displayed.

  @draft
  Scenario: FC1.5 Display a course using Course view
    Given I am logged in as Faculty
    When I view the details of a course using Find a Course
    Then I can view all the details of the course on course review




