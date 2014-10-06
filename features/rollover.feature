@nightly @yellow_team
Feature: CO.Rollover

  As a central administrator, I want to manually trigger the rollover process so that eligible course
  offering data from the source term will be copied over to create new course offerings in the target term.

  MSR 1.1: As Central Administrator, I want actual scheduling information on AOs in a source term to be copied to
  requested scheduling information on AOs in the target term when performing a simple rollover

  CO 28.1 As a central administrator I want a rollover option to exclude room assignments for an Activity Offering from Rollover

  CO 28.2 As a Central Administrator I want a rollover option to exclude scheduling information for an Activity Offering from Rollover

  CO 28.3 As a Central Administrator I want a rollover option to exclude instructional assignments for an Activity Offering

  CO 28.4: As a Central Administrator I want a rollover option to exclude Activity Offerings with a state of Canceled in the source term

  CO 28.8: As a Central Administrator I want to apply a default configuration for rollovers

  CO 28.10: As a Central Administrator I want to apply a rollover configuration for courses in a particular subject code

  CO 28.11: As a Central Administrator I want to apply a rollover configuration for a specific course

  CO 28.12: As a Central Administrator I want to have different rollover configurations for different term types

  CO 28.13: As a Central Administrator I want to have a rollover configuration to apply only to a specific term

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: RG 6.1/MSR 1.1 Successfully rollover courses to target term copying course offerings etc
    Given I have created an additional activity offering cluster for a course offering
    When I initiate a rollover by specifying source and target terms
    Then the results of the rollover are available
    And the rollover can be released to departments
    #And course offerings are copied to the target term
    And the activity offering clusters, assigned AOs and reg groups are rolled over with the course offering
    And the activity offering scheduling information are copied to the rollover term as requested scheduling information

  Scenario: CO 28.8.1 Successfully rollover course offerings where default institution level configuration rules apply
    Given that a default institutional rollover configuration is defined in the GES with a value of 'copy' for scheduling information
    And 'copy' for Bldg/Rm information
    And 'copy' for instructional assignments
    And 'not copy' for canceled AOs
    When the rollover is executed for a term with course offerings that are not covered by a more granular rollover rule
    Then course offerings are copied from the source term to the target term
    And activity offerings are copied to the target term excluding those in cancelled status
    And the scheduling information including Bldg/Rm info is copied to the target term AOs
    And instructional assignments are copied to the target term AOs

  Scenario: CO 28.10.1 Successfully rollover course offerings where subject level configuration rules apply and show higher level rules are overridden
    Given that a subject level rollover configuration is defined for ENGL in the GES with no value for scheduling information
    And 'not copy' for instructional assignments
    And 'copy' for canceled AOs
    When the rollover is executed for a term with course offerings with ENGL subject code that are not covered by a more granular rollover rule
    Then course offerings are copied from the source term to the target term
    And activity offerings are copied to the target term including those in cancelled status
    And the scheduling information including Bldg/Rm info is copied to the target term AOs
    And the instructional assignments are not copied to the target term AOs

  Scenario: CO 28.11.1 Successfully rollover course offerings where course code configuration rules apply and show higher level rules are overridden
    Given that a course code rollover configuration is defined for a specific course in the GES with a value of 'not copy' for scheduling information
    And 'copy' for instructional assignments
    And 'not copy' for canceled AOs
    And the rollover is executed for a term with the specified course offering
    Then course offerings are copied from the source term to the target term
    And activity offerings are copied to the target term excluding those in cancelled status
    And the scheduling information is not copied to the target term AOs
    And instructional assignments are copied to the target term AOs

    @draft
  Scenario: CO 28.2.1 Confirm GES rollover settings that specify the scheduling information should not be copied, then the Bldg/Rm data is not copied regardless of the applicable Bdlg/Rm rollover config
    Given that a course code rollover configuration is defined for a specific course in the GES with a value of 'not copy' for scheduling information
    And no specific rule is configured at the specific course code for Bldg/Rm
    But a 'copy' Bldg/Rm rule is configured at the term level that applies to the specified course code
    When the rollover is executed for a term with the Bldg/Rm rule and with the specified course offering
    Then course offerings are copied from the source term to the target term
    And activity offerings are copied to the target term including those in cancelled status
    And the scheduling information (including bldg/room info) is not copied to the target term AOs

  @fails_on_bldg_not_blank
  Scenario: CO 28.1.1 Confirm GES settings to rollover scheduling information but exclude Bldg/Rm data
    Given that a course code rollover configuration is defined for a specific course in the GES with a value of 'copy' for scheduling information
    And 'not copy' for Bldg/Rm
    When the rollover is executed for a term with the specific course with Bldg/Rm and scheduling information rules
    Then course offerings are copied from the source term to the target term
    And activity offerings are copied to the target term excluding those in cancelled status
    And the scheduling information excluding Bldg/Rm info is copied to the target term AOs

  @draft
  Scenario: CO 28.12.1 Apply term type rules for a subject level rollover configuration
    Given that a subject level rollover configuration has been defined for ENGL in the GES for a specific term type
    And there is a value of 'copy' for instructional assignments
    And 'not copy' for canceled AOs
    When the rollover is executed for the specified term type with ENGL courses not covered by a more granular rules
    Then course offerings are copied from the source term to the target term
    And activity offerings are copied to the target term excluding those in cancelled status
    And instructional assignments are copied to the target term AOs

  @draft @run_one_time_only_terms_hard_coded
  Scenario: CO 28.13.1 Apply term-specific rules for a subject level rollover configuration
    Given that a subject level rollover configuration has been defined for ENGL in the GES for a specific term
    And there is a value of 'not copy' for instructional assignments
    And 'copy' for canceled Bldg/Rm
    When the rollover is executed for the specified term
    Then course offerings are copied from the source term to the target term
    And activity offerings are copied to the target term excluding those in cancelled status
    And the scheduling information including Bldg/Rm info is copied to the target term AOs
    And the instructional assignments are not copied to the target term AOs