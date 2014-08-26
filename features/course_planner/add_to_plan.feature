@wip
Feature: BT.Add note to planner

  Background:

    Given I am logged in as a Student

@wip
  Scenario: CS 1.5.1 Add notes to my plan from course search
    Given There is an existing unplanned course
    When I search for a course from course search
    And  I add the course with notes and term to myplan
    Then the course with notes appears under the term on the planner

@wip
  Scenario: CS 1.5.2 Edit the notes to my plan from the courses listed in the planner
    Given I work on scheduled planner
    When I edit the notes of a course under a current term
    Then the course should appear under current term with updated notes

@wip

Scenario: PL 1.0.1 Add course(CM) from Search to Planned section
  When I search for a course(CM) from course search
  And I add the course(CM) from Search to the Planned section for a sepcific term
  Then the course should be there in the Planner


  @wip
  Scenario: PL 1.0.2 Add course(CM) from CDP top to Planned section

    When I navigate to the Course Section Details
    And I add the course(CM) from the CDP details page
    Then the course should be there in the Planner



  @wip
  Scenario: PL 1.0.3 Add course (CM) from Search to Backup section

    When I search for a course(CM)
    And I add the course(CM) from Search to the Backup section for a sepcific term
    Then the course should be there in the backup section of the planner


  @wip
  Scenario: PL 1.0.4 Add course(CM) from CDP top to Backup section

    When I navigate to the Course Section Details
    And I add the course(CM) from the CDP details page to the Backup section
    Then the course should be there in the Backup section of the planner


    @wip

  Scenario: PL 1.0.5 Add Course Offering(Single Activity) to a term in my plan

    When I search for a course with Single Activity Offerings
    Then I should be able to add the course to my plan


  @wip


  Scenario: PL 1.0.6 Add Course Offering(Multiple Activity) to a term in my plan

    When I search for the course with Multiple Activity Offerings
    And I select the activity offerings
    Then I should be able to add the course with Multiple Activity Offerings to my plan


  @wip

  Scenario: PL 1.0.7 Add Course Offering(Multiple Activity) to a term in my plan

    When I search for the course with Multiple Format Offerings
    And I select the format offerings
    Then I should be able to add the course with Multiple Format Offerings to my plan

