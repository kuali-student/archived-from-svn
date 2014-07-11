# Created data used for testing
#
# CMRequisitesData contained in Course Proposal
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in  )
#  @editAgenda = make ManageCORequisitesData
#  @editAgenda.create_data_advanced_search(section, course)
# Methods:
#  @initialize(browser, opts={})
#
# Note the use of the ruby options hash pattern re: setting attribute values

class CmRequisitesRuleData < DataFactory
  include Foundry

  attr_accessor :submit_btn,
                :section,
                :default_rule

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :section => "Student Eligibility & Prerequisite",
        :default_rule => "Permission of instructor required"
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def open_agenda_section
    sections = {"Student Eligibility & Prerequisite"=>:eligibility_prereq_section,
                "Antirequisite"=>:antirequisite_section, "Corequisite"=>:corequisite_section,
                "Recommended Preparation"=>:recommended_prep_section,
                "Repeatable for Credit"=>:repeatable_credit_section,
                "Course that Restricts Credits"=>:restricted_credit_section}
    on CmCourseRequisites do |page|
      page.loading.wait_while_present(60)
      if !page.send(sections[@section]).span(id: /Course-AgendaManage-RulePrototype_rule[A-Z]_toggle_exp/).visible?
        page.send(sections[@section]).when_present.click
      end
    end
  end

end

class CmRequisiteRule < CmRequisitesRuleData
  include Foundry

  attr_accessor :submit_btn,
                :section,
                :course

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :section => "Corequisite",
        :default_rule => "Must be concurrently enrolled in <course>",
        :course => "ENGL101"
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def cr_edit_add( edit_or_add)
    begin
      open_agenda_section
      on CmRequisiteRules do |page|
        if edit_or_add == "add"
          page.coreq_add
        else
          page.coreq_edit
        end
      end
    rescue Watir::Wait::TimeoutError
      #means Data setup was not needed
      on CmRequisiteRules do |page|
        page.alert.ok
      end
    end
  end

  def cr_data_setup( number_statements_to_add = 10)
    navigate_to_requisites
    on CmRequisiteRules do |page|
      page.loading.wait_while_present
      page.show_disclosure("coreq")
      if page.coreq_edit_link.exists?
        page.coreq_edit
      else
        page.coreq_add
      end
      page.loading.wait_while_present
      if cr_create_rule_tree( number_statements_to_add)
        commit_changes( return_to_edit_page = true)
      end
    end
  end

end