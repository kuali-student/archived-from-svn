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
      when "Student Eligibility & Prerequisite"
        adding_rule_student_eligibility
      when "Corequisite"
        adding_rule_corequisite
      when "Recommended Preparation"
        adding_rule_recommended_preparation_rule
      when "Antirequisite"
        adding_rule_antirequisite
      when "Repeatable for Credit"
        adding_rule_repeatable_for_credit
      when "Course that Restricts Credits"
        adding_course_that_restricts_credits
      else
        raise "No requisite rule section defined!"
    end
    determine_save_action unless @defer_save
  end

  def edit (opts={})
    view
    if opts[:requisite_type] == REQUISITE_TYPE_PREREQUISITE
      edit_rule_student_eligibility :logic_operator => opts[:logic_operator],
                                    :left_group_node => opts[:left_group_node],
                                    :right_group_node => opts[:right_group_node]
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
      #STUDENT ELIGIBILITY #A,G,M,S,
      begin
        page.edit_rule_student_eligibility
      rescue Exception => e
        page.edit_rule('Y')
      end
      edit_A_rule :left_group_node => opts[:left_group_node] unless opts[:left_group_node].nil?
      edit_B_rule :right_group_node => opts[:right_group_node] unless opts[:right_group_node].nil?
      edit_operator :logic_operator => opts[:logic_operator] unless opts[:logic_operator].nil?

      update_adding_rules
    end
  end

  def edit_A_rule (opts={})
    edited_rule = opts[:left_group_node]
    on CmRequisiteRules do |page|
      page.rule_a_element_link.click
      page.loading_wait
      page.edit_btn
      page.course_field.fit opts[:left_group_node].course
    end
    edited_rule.preview_rule_changes
  end

  def edit_B_rule (opts={})
    edited_rule = opts[:right_group_node]
    on CmRequisiteRules do |page|
      # add editing contents
    end
    edited_rule.preview_rule_changes
  end

  def edit_operator (opts={})
    on CmRequisiteRules do |page|
      page.select_rule_operator.fit opts[:logic_operator]
      page.loading_wait
    end
  end

  def adding_rule_student_eligibility
    on CmCourseRequisitesPage do |page|
      page.expand_all_rule_sections
      sleep 3
      #STUDENT ELIGIBILITY #A,G,M,S
      begin
        page.add_rule_student_eligibility
      rescue Exception => e
        page.add_rule('AE')
      end

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
      begin
        page.add_rule_recommended_prep
      rescue Exception => e
        page.add_rule('AA')
      end
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
      begin
        page.add_rule_corequisite
      rescue Exception => e
        page.add_rule('AF')
      end

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
      begin
        page.add_rule_antirequisite
      rescue Exception => e
        page.add_rule('AB')
      end

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
      begin
        page.add_rule_repeatable_for_credit
      rescue Exception => e
        page.add_rule('AC')
      end

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
        begin
          page.add_rule_restricts_credits
        rescue Exception => e
          page.add_rule('AD')
        end

        unless @rule_list.nil?
          @rule_list.each do |rule|
            rule.create
          end
        end
        update_adding_rules
    end
  end

end
