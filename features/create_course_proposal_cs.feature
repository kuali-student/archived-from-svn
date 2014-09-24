@nightly
Feature: GT.Create a Course Proposal as a Curriculum Specialist

Background:
Given I am logged in as Curriculum Specialist

Scenario:  CC.1.1 Create Course Proposal from blank
When I create a course proposal from blank
Then I should see a blank course proposal

Scenario: CC.1.2 Cancel Create a Course proposal process
When I create a course proposal
And I cancel create a course
Then I should see CM Home


Scenario: CC.3.1 Create a course proposal with only required fields
When I complete the required for save fields on the course proposal and save
Then I should see data in required for save fields for the course proposal
And I should see data in required for save fields on the Review Proposal page
And I edit the required for save fields and save
Then I should see the updated data on the Review proposal page


Scenario: CC4.1 Create a course admin proposal with required fields and review
When I complete the required fields on the course admin proposal
Then I should see data in required fields for the admin proposal
And I perform a full search for the course proposal
Then I can review the required fields on the admin proposal


Scenario: CC4.2 Create course without required for save fields
When I am on the course information page and I click save progress without entering any values
Then I should receive an error message about the proposal title and course title being required for save


Scenario: CC6.1 Create Course Proposal from Approved Course
When I create a course proposal from a copy of an approved course
Then I should see a new course proposal with a modified course title
And I should see all the copied details of the course on the Review Proposal page


Scenario: CC6.2 Create Course Admin Proposal from Approved Course
When I create a course admin proposal from a copy of an approved course
Then I should see a new course admin proposal with a modified course title
And I should see all the copied details of the course on the Review Proposal page


Scenario: CC7.1 Create Course Proposal from Proposed Course
Given I have a course proposal created as Faculty
When I create a course proposal from a copy of a proposed course
Then I should see a new course proposal with modified titles
And I should see all the copied details of the proposal on the Review Proposal page


Scenario: CC7.2 Create Course Admin Proposal from Proposed Course
Given I have a course proposal created as Faculty
When I create a course admin proposal from a copy of a proposed course
Then I should see a new course admin proposal with modified titles
And I should see all the copied details of the proposal on the Review Proposal page


Scenario: CC4.3 Create a course admin proposal with all fields and review
When I complete all fields on the create course admin proposal
And I perform a full search for the create course admin proposal
Then I can review all details on the create course admin proposal




