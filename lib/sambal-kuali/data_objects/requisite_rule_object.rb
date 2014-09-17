class CmRequisiteRuleObject < CmBaseObject

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
    on CmRequisiteRulesPage do |page|

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

        selected_row_num = 0
        total_courses_to_be_selected = @completed_course_number
        while selected_row_num < total_courses_to_be_selected do
          # Enter course Code text
          enter_rule_text(selected_row_num)
          page.add_course_code
          selected_row_num +=1
        end

        page.completed
        page.loading_extended_wait
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
    rule_level = opts[:rule_level].to_i
    req_level = opts[:requisite_level].to_i
    operator_level = opts[:rule_level].to_i + 1
    on CmRequisiteRulesPage do |page|
      page.rule_element_link(rule_level).click
      page.loading_wait
      page.edit_btn
      page.course_field.fit @course
    end
    preview_rule_changes
    edit_operator(opts[:operator], req_level, operator_level) unless opts[:operator].nil?
  end

  def edit_operator (operator, req_level, operator_level)
    on CmRequisiteRulesPage do |page|
      page.select_rule_operator(req_level, operator_level).fit operator
      page.loading_wait
    end
  end

  def preview_rule_changes
    on CmRequisiteRulesPage do |page|
        page.preview_change
    end
  end

  def enter_rule_text (index)
    on CmRequisiteRulesPage do |page|
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
      page.select_row(index)
    end
  end

end
