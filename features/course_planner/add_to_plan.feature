@nightly
Feature: BT.Add note to planner

  Background:

    Given I am logged in as a Student

  @nightly
Scenario: PL 1.0.1 Add course(CM) from Search to Planned section
  When I search for a course(CM) from course search
  And I add the course(CM) from Search to the Planned section for a sepcific term
  Then the course should be there in the Planner


  @nightly
  Scenario: PL 1.0.2 Add course(CM) from CDP top to Planned section

    When I navigate to the Course Section Details
    And I add the course(CM) from the CDP details page
    Then the course should be there in the Planner



  @nightly
  Scenario: PL 1.0.3 Add course (CM) from Search to Backup section

    When I search for a course(CM)
    And I add the course(CM) from Search to the Backup section for a sepcific term
    Then the course should be there in the backup section of the planner


  @nightly
  Scenario: PL 1.0.4 Add course(CM) from CDP top to Backup section

    When I navigate to the Course Section Details
    And I add the course(CM) from the CDP details page to the Backup section
    Then the course should be there in the Backup section of the planner


  @nightly

  Scenario: PL 3.0.5 Add Course Offering(Single Activity) to a term in my plan

    When I search for a course with Single Activity Offerings
    Then I should be able to add the course to my plan


  @nightly


  Scenario: PL 3.0.6 Add Course Offering(Multiple Activity) to a term in my plan

    When I search for the course with Multiple Activity Offerings
    And I select the activity offerings
    Then I should be able to add the course with Multiple Activity Offerings to my plan


  @nightly

  Scenario: PL 3.0.7 Add Course Offering(Multiple Activity) to a term in my plan

    When I search for the course with Multiple Format Offerings
    And I select the format offerings
    Then I should be able to add the course with Multiple Format Offerings to my plan

