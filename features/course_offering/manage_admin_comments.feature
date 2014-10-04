@nightly @yellow_team
Feature: CO.Manage Admin Comments

  CO 27.1 As an Administrator I want to add a comment to a course offering so that special information or requests are recorded

  CO 27.2 As an Administrator I want to add a comment on an Activity Offering so that special information or requests are recorded

  CO 27.3 As an Administrator I want to view comments placed on a Course Offering so that I can assess or act on the information

  CO 27.4 As an Administrator I want to to view comments placed on an Activity Offering so that I can assess or act on the information

  CO 27.5 As an Administrator I want to to delete a comment attached to a Course Offering so that I can remove information that is no longer relevant

  CO 27.6 As an Administrator I want to delete a comment attached to an Activity Offering so that I can remove information that is no longer relevant

  CO 27.7 As an Administrator I want to to edit a comment attached to a Course Offering so that I can correct or update information

  CO 27.8 As an Administrator I want to edit a comment attached to an Activity Offering so that I can correct or update information

  CO 27.9 As an Administrator I want to have appropriate authorization to add or edit comments

  CO 27.10 As an Administrator I want to be able to include rich text formatting in administrative comments on Course Offerings and Activity
  Offerings so that I can draw attention to text or include actionable urls and email addresses

  Scenario: CO 27.1.1 Verify successful add of admin comment to a course offering
    Given I am logged in as a Schedule Coordinator
    When I add a comment to a course offering
    Then the course offering comment can be viewed successfully

  Scenario: CO 27.2.1 Verify successful add of admin comment to an activity offering
    Given I am logged in as a Schedule Coordinator
    When I add a comment to an activity offering
    Then the activity offering comment can be viewed successfully

  Scenario: CO27.5.1 Verify successful deletion of comment on course offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for a course offering with existing comments
    When I delete an existing comment for the course offering
    Then the course offering comment is successfully deleted

  Scenario: CO27.5.2 Verify user can cancel deletion of comment on course offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for a course offering with existing comments
    When I select the delete option for an existing course offering comment but choose not to confirm the deletion
    Then the course offering comment is not deleted and can be viewed successfully

  Scenario: CO27.6.1 Verify successful deletion of comment on activity offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for an activity offering with existing comments
    When I delete an existing comment for the activity offering
    Then the activity offering comment is successfully deleted

  Scenario: CO27.6.2 Verify user can undo deletion of comment on activity offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for an activity offering with existing comments
    When I select the delete option for an existing activity offering comment but choose not to confirm the deletion
    Then the activity offering comment is not deleted and can be viewed successfully

  Scenario: CO27.7.1 Verify successful edit of comment on course offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for a course offering with existing comments
    When I edit an existing course offering comment and save
    Then the course offering comment is updated successfully

  Scenario: CO27.7.2 Verify user can cancel the editing of comment on course offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for a course offering with existing comments
    When I edit an existing course offering comment and cancel
    Then the course offering comment is not updated

  Scenario: CO27.8.1 Verify successful edit of comment on activity offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for an activity offering with existing comments
    When I edit an existing activity offering comment and save
    Then the activity offering comment is updated successfully

  Scenario: CO27.8.2 Verify user can cancel the editing of comment on activity offering
    Given I am logged in as a Schedule Coordinator
    And I manage comments for an activity offering with existing comments
    When I edit an existing activity offering comment and cancel
    Then the activity offering comment is not updated

  Scenario: CO 27.9.1 Verify Department Schedule Coordinator (Carol) permissions on admin comments created for course offerings in her admin org
    When I am logged in as a Department Schedule Coordinator
    And I manage comments for a course offering in my admin org
    Then I am able to add new admin comments for the course offering
    And I am able to edit comments for the course offering
    And I am able to delete comments for the course offering

  Scenario: CO 27.9.2 Verify Department Schedule Coordinator (Carol) permissions on admin comments created for activity offerings in her admin org
    When I am logged in as a Department Schedule Coordinator
    And I manage comments for an activity offering in my admin org
    Then I am able to add new comments for the activity offering
    And I am able to edit comments for the activity offering
    And I am able to delete comments for the activity offering

  Scenario: CO 27.9.3 DSC (Carol) has read-only permission on admin comments created for course offerings NOT in her admin org
    Given there is a course offering with existing comments
    When I am logged in as a Department Schedule Coordinator
    And I manage existing comments for a course offering outside my admin org
    Then I am able to view the comments for the course offering
    But I am not able to edit the comments for the course offering
    And I am not able to delete the comments for the course offering
    And I am not able to create new comments for the course offering

  Scenario: CO 27.9.4 DSC (Carol) has read-only permission on admin comments created for activity offerings NOT in her admin org
    Given there is an activity offering with existing comments
    When I am logged in as a Department Schedule Coordinator
    And I manage existing comments for an activity offering outside my admin org
    Then I am able to view the comments for the activity offering
    But I am not able to edit the comments for the activity offering
    And I am not able to delete the comments for the activity offering
    And I am not able to create new comments for the activity offering

  Scenario: CO27.10.1 Verify user can include url and email hyperlinks in new admin comments on course and activity offerings
    Given I am logged in as a Schedule Coordinator
    When I add a new comment which includes a url hyperlink to a course offering
    Then the course offering comment is saved with a working hyperlink

  Scenario: CO27.10.2 Verify user can include url and email hyperlinks in existing admin comments on course and activity offerings
    Given I am logged in as a Schedule Coordinator
    And I manage comments for an activity offering with existing comments
    When I edit a comment and add a url hyperlink
    Then the activity offering comment is saved with a working hyperlink

  Scenario: CO27.10.3 Verify user can include typography elements such as underlining, bolding, and italics in new admin comments on course and activity offerings
    Given I am logged in as a Schedule Coordinator
    When I add a new comment with formatted (bold) text to a course offering
    Then the course offering comment is saved with the typography elements displayed

  Scenario: CO27.10.4 Verify user can include typography elements such as underlining, bolding, and italics in existing admin comments on course and activity offerings
    Given I am logged in as a Schedule Coordinator
    And I manage comments for an activity offering with existing comments
    When I edit a comment and format (bold) some of the text
    Then the activity offering comment is saved with the typography elements displayed

  @wip
  Scenario: CO 28.8.? Verify admin comments are not copied to a new term when a rollover is performed
