@nightly
Feature: GT.Edit Course Proposal for both Fred and CS

Scenario: EP1.1 Edit the Course Proposal - CS
  Given I have a course admin proposal created as Curriculum Specialist
  When I perform a full search for the course proposal
  And I edit the course proposal
  Then I should see updated data on the Review proposal page


Scenario: EP1.2 Edit the Course Proposal - Faculty
  Given I have a course proposal created as Faculty
  When I perform a full search for the course proposal
  Then I edit the course proposal created as Faculty
  And I should see updated data of the Faculty proposal on the Review proposal page


Scenario: EP1.3 Edit the faculty proposal - CS
  Given I have a course proposal created as Faculty
  When I am logged in as Curriculum Specialist
  Then I perform a search for the course proposal
  And I edit the basic details of the course proposal
  And I should see the basic details of of the updated data on the Review proposal page


Scenario: EP1.4 Faculty cannot edit CS proposal
  Given I have a course admin proposal created as Curriculum Specialist
  When I am logged in as Faculty
  Then I perform a search for the course proposal
  And I should not see the edit option in the search results for the Course Admin Proposal