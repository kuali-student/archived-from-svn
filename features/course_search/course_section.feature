@nightly
Feature: BT.Course Section

Background:
Given I am logged in as a Student

  Scenario: Verify that I am able to see the section details of the course in the Course Details page
    When I search for a certain course on course search page
    And I navigate to the Course Section Details page
    Then I should be able to view the section details about the course


  Scenario:Verify that I am able to see the format offerings of a course offering and its associated activity offering so that I can decide what to add to my plan
    When I search for course which has format offerings on the course search page
    And I navigate to the Course Section Details page
    Then I should be able to view the format offerings for the course



  Scenario:Verify that  I am able to see an option to add Multiple Activity Offerings to my Plan
    When I add a course with multiple activity offerings to my plan
    And I select the activity offerings
    Then I should be able to see an option to add multiple offerings to my plan



  Scenario:Verify that  I am able to see an option to add Single Activity Offering to my Plan
    When I search for a course with Single Activity Offering
    And I navigate to the Course Section Details page
    Then I should be able to see an option to add the course to my plan


  Scenario:Verify that  I am able to see website and restriction links for a course
    When I search for a course with website and restrictions link
    And I navigate to the Course Section Details page
    Then I should be able to see the website and restriction links for the course


  Scenario:Verify that  I am able to see an option to add course with variable credits to my Plan
    When I search for a course with variable credits
    And I navigate to the Course Section Details page
    Then I should be able to see an option to add a course with variable credits to my plan


