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

class CmRequisiteRuleObject < DataFactory
  include Foundry

  attr_accessor :type,
                :rule,
                :course,
                :completed_course_number,
                :course_combination_type,
                :add_method,
                :search_title,
                :search_phrase,
                :search_course_code,
                :complete_rule_text,
                :logic_operator,
                :repeatable_for_credit_credit

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :type => "Student Eligibility & Prerequisite",
        :rule => "Permission of instructor required",
        :course => "ENGL201",
        :add_method => "text",
        :search_title => "English",
        :search_phrase => "ENGL",
        :complete_rule_text => "Permission of instructor required"
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def create
    on CmRequisiteRules do |page|

      page.add_btn
      page.loading_wait
      page.rule_statement_option.fit @rule

      page.loading_wait

      if  @rule == 'Must have successfully completed <course>'
        @complete_rule_text = @rule.sub('<course>', @course)
        # Enter text
        enter_rule_text(0)
      end

      if @rule == 'Must successfully complete a minimum of <n> courses from <courses> with a minimum grade of <gradeType> <grade>'

        #enter  Number of Courses:
        page.integer_field.fit @completed_course_number

        #pick the courses, dynamic course ranges, or Course sets.
        page.multi_course_dropdown.fit @course_combination_type

        i = 0
        num = @completed_course_number
        while i < num do
          # Enter course Code text
          enter_rule_text(i)
          page.add_course_code
          i +=1
        end

        page.completed
        page.loading_wait
        page.grade_dropdown.fit "A"
      end

      if  @rule == 'Must be concurrently enrolled in <course>'
        enter_rule_text(0)
      end

      if @rule == 'Must not have successfully completed <course>'
        enter_rule_text(0)
      end

      if @rule == 'May be repeated for a maximum of <n> credits'
        page.integer_field.when_present.set @repeatable_for_credit_credit
      end

      if @rule == 'Must not have successfully completed <course>'
        enter_rule_text(0)
      end

      preview_rule_changes
    end
  end

  def edit (opts ={})

  end

  def preview_rule_changes
    on CmRequisiteRules do |page|
        page.preview_change
    end
  end

  def enter_rule_text (index)
    on CmRequisiteRules do |page|
      # Enter text
      if @add_method == 'text'
        puts 'add text ' + @course
        page.course_field.fit @course
      end

      if @add_method == 'advanced'
        puts 'advanced search ' + @search_course_code
        page.search_link
        rule_advanced_search("course code", @search_course_code, index)
      end
    end
  end

  def rule_advanced_search(field, search_text, index)
    on CmRequisiteAdvancedSearchPage do |page|
      if field == "course title"
        page.search_course_title.fit search_text
      elsif field == "course code"
        page.search_course_code.fit search_text
      elsif field == "description"
        page.adv_plain_text_description.fit search_text
      end
      page.course_search
      sleep 5
      page.select_result(index)
    end
  end

end
