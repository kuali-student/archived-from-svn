# course requisite used for testing
#
# CMRequisites contained in Course Proposal
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Methods:
#  @initialize(browser, opts={})
#
# Note the use of the ruby options hash pattern re: setting attribute values

class CmCourseRequisite < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :requisite_type,
                :left_group_node,
                :right_group_node,
                :third_group_node,
                :rule_logic_text,
                :logic_operator,
                :rule_list

  REQUISITE_TYPE_PREREQUISITE = "Student Eligibility & Prerequisite"
  REQUISITE_TYPE_CO_REQUISITE  = "Corequisite"
  REQUISITE_TYPE_RECOMMENDED_PREPARATION = "Recommended Preparation"
  REQUISITE_TYPE_ANTI_REQUISITE = "Antirequisite"
  REQUISITE_TYPE_REPEATABLE_FOR_CREDIT = "Repeatable for Credit"
  REQUISITE_TYPE_RESTRICTS_CREDITS = "Course that Restricts Credits"


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        requisite_type: REQUISITE_TYPE_PREREQUISITE,
        logic_operator: "AND"
    }
    set_options(defaults.merge(opts))

  end

  def create
    view
    case @requisite_type
      when REQUISITE_TYPE_PREREQUISITE #"Student Eligibility & Prerequisite"
        adding_rule_student_eligibility
      when REQUISITE_TYPE_CO_REQUISITE #"Corequisite"
        adding_rule_corequisite
      when REQUISITE_TYPE_RECOMMENDED_PREPARATION #"Recommended Preparation"
        adding_rule_recommended_preparation_rule
      when REQUISITE_TYPE_ANTI_REQUISITE #"Antirequisite"
        adding_rule_antirequisite
      when REQUISITE_TYPE_REPEATABLE_FOR_CREDIT #"Repeatable for Credit"
        adding_rule_repeatable_for_credit
      when REQUISITE_TYPE_RESTRICTS_CREDITS #"Course that Restricts Credits"
        adding_course_that_restricts_credits
      else
        raise "No requisite rule section defined!"
    end
    determine_save_action unless @defer_save
  end

  def edit (opts={})
    view
    if opts[:rule_logic_text] != nil
      on(CmCourseRequisitesPage).edit_rule_student_eligibility
      on CmRequisiteRules do |rule|
        rule.edit_rule_logic_action
        rule.rule_logic_text.wait_until_present
        rule.rule_logic_text.set opts[:rule_logic_text]
        rule.rule_logic_preview
        sleep 5 #TO avoid random edit failures.
        rule.update_rule_btn
        sleep 5 #TO avoid random edit failures.
      on(CmCourseInformation).save_progress
      end
    end

    if opts[:rule_logic_text].nil?
    if opts[:requisite_type] == REQUISITE_TYPE_PREREQUISITE
      edit_rule_student_eligibility :logic_operator => opts[:logic_operator],
                                    :left_group_node => opts[:left_group_node],
                                    :right_group_node => opts[:right_group_node]
    end
    end
    set_options(opts)
  end

  def view
    on CmCourseInformation do |page|
      page.course_requisites unless page.current_page('Course Requisites').exists?
    end
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
    end
  end

  def edit_rule_student_eligibility (opts={})
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
      sleep 3
      #STUDENT ELIGIBILITY #A,G,M,S,Y,AE
      page.edit_rule_student_eligibility

      opts[:left_group_node].edit :rule_level => '0', :requisite_level => '0', :operator => opts[:logic_operator] unless opts[:left_group_node].nil?
      opts[:right_group_node].edit :rule_level => '2', :requisite_level => '0', :operator => opts[:logic_operator] unless opts[:right_group_node].nil?
      update_adding_rules
    end
  end

  def adding_rule_student_eligibility
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
      sleep 3
      #STUDENT ELIGIBILITY #A,G,M,S
      page.add_rule_student_eligibility

      unless @rule_list.nil?
        @rule_list.each do |rule|
          rule.create
        end
      end
      update_adding_rules
    end
  end

  def adding_rule_recommended_preparation_rule
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
      #recommended_preparation C,I,O,U
      page.add_rule_recommended_prep

      @rule_list.each do |rule|
        rule.create
      end
      update_adding_rules
    end
  end

  def update_adding_rules
    on CmRequisiteRules do |page|
      page.update_rule_btn
      page.loading_wait
    end
  end

  def adding_rule_corequisite
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
      sleep 3
      #corequisite: B,H,N,T,Z,AF
      page.add_rule_corequisite

      unless @rule_list.nil?
        @rule_list.each do |rule|
          rule.create
        end
      end
      update_adding_rules
    end
  end

  def adding_rule_antirequisite
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
      sleep 3
      #antirequisite: D,J,P,V,AB
      page.add_rule_antirequisite

      unless @rule_list.nil?
        @rule_list.each do |rule|
          rule.create
        end
      end
      update_adding_rules
    end
  end

  def adding_rule_repeatable_for_credit
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
      sleep 2
      #repeatable_for_credit: E,K,Q,W,AC
      page.add_rule_repeatable_for_credit

      unless @rule_list.nil?
        @rule_list.each do |rule|
          rule.create
        end
      end
      update_adding_rules
    end
  end

  def adding_course_that_restricts_credits
    on CmCourseRequisitesPage do |page|
        page.expand_all_rule_sections
        sleep 2
        #restricts_credits: F,L,R,X, AD
        page.add_rule_restricts_credits

        unless @rule_list.nil?
          @rule_list.each do |rule|
            rule.create
          end
        end
        update_adding_rules
    end
  end

end
