@test_data @test
Feature: Test Data Creation Feature

  Scenario: Create a proposal with all fields filled in
    Given I am logged in as Faculty
    When I create a proposal with all fields populated
    Then the proposal is successfully created
