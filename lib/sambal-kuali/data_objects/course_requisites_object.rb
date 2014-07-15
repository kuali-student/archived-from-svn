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
                :current_rule

  REQUISITE_TYPE_PREREQUISITE = "Prerequisite"
  REQUISITE_TYPE_CO_REQUISITE  = "Corequisite"
  REQUISITE_TYPE_RECOMMENDED_PREPARATION = "Recommended Preparation"
  REQUISITE_TYPE_ANTI_REQUISITE = "Antirequisite"
  REQUISITE_TYPE_REPEATABLE_FOR_CREDIT = "Repeatable for Credit"
  REQUISITE_TYPE_RESTRICTS_CREDITS = "Course that Restricts Credits"


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        requisite_type: REQUISITE_TYPE_PREREQUISITE,
        current_rule: [(make CmRequisiteRuleObject)],
        logic_operator: "AND"
    }
    set_options(defaults.merge(opts))

  end

  def create
    view
    on CmCourseRequisites do |page|
      page.expand_all_rule_sections
      on CmRequisiteRules do |rule_page|
             rule_page.create_requisite_rule
      end
    end
    determine_save_action unless @defer_save
  end
end
