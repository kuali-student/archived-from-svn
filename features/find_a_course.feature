@draft
Feature: GT.Find a Course

  Scenario: FC1.1 Verify empty search string results in validation error
    Given I am logged in as Faculty
    When I perform a blank search for Courses
    Then I get a course code required validation error

  Scenario: FC1.2 Verify partial search string on Course code returns correct results
    Given I am logged in as Curriculum Specialist
    When I perform a partial search for Courses
    Then I get the results matching the search criteria

  Scenario: FC1.3 Verify full search string on Course Code returns correct results
    Given I am logged in as Faculty
    When I perform a full search for Courses
    Then I get correct course returned on the search

  Scenario: FC1.4 Verify that no matching results message is displayed
    Given I am logged in as Curriculum Specialist
    When I perform an invalid search for Courses
    Then a message indicating no matching records is displayed.




