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
                :logic_operator

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
        if @add_method == 'text'
          puts 'student text'
          page.course_field.fit @course
        end

        if @add_method == 'advanced'
          puts 'student advanced'
          page.advanced_search
          #pick one field
          page.adv_course_title.fit @search_title
          page.adv_course_code_rule.fit @course
          page.adv_plain_text_description_rule.fit @search_phrase
          page.adv_search
          #number is the column number 1 = course title, 2 = Course Code, 4 = Description
          return_search_result(@course, 2)
        end
      end

      if @rule == 'Must successfully complete a minimum of <n> courses from <courses> with a minimum grade of <gradeType> <grade>'

        #enter  Number of Courses:
        page.integer_field.fit @completed_course_number

        #pick the courses, dynamic course ranges, or Course sets.
        page.multi_course_dropdown.fit @course_combination_type

        $i = 0
        $num = @completed_course_number
        while $i < $num do
          # Enter course Code text
          if @add_method == 'text'
            puts 'course Code text'
            page.course_field.fit @course
          end

          if @add_method == 'advanced'
            puts 'advanced search'
            page.search_link
            #pick one field
            #page.adv_course_code_rule.fit @search_course_code
            #page.adv_search
            #number is the column number 1 = course title, 2 = Course Code, 4 = Description
            #page.select_course($i)
            rule_advanced_search("course code", @search_course_code, $i)
          end
          page.add_course_code
          $i +=1
        end

        page.completed
        page.loading_wait
        page.grade_dropdown.fit "A"

      end

      preview_rule_changes
    end
  end

  def edit (opts ={})

  end

  def open_agenda_section
    sections = {"Student Eligibility & Prerequisite"=>:eligibility_prereq_section,
                "Antirequisite"=>:antirequisite_section, "Corequisite"=>:corequisite_section,
                "Recommended Preparation"=>:recommended_prep_section,
                "Repeatable for Credit"=>:repeatable_credit_section,
                "Course that Restricts Credits"=>:restricted_credit_section}
    on CmCourseRequistitesPage do |page|
      page.loading.wait_while_present(60)
      if !page.send(sections[@section]).span(id: /Course-AgendaManage-RulePrototype_rule[A-Z]_toggle_exp/).visible?
        page.send(sections[@section]).when_present.click
      end
    end
  end

  def navigate_to_requisite
    on CmCourseRequistitesPage do |page|
      page.course_requisites unless page.current_page('Course Requisites').exists?
    end
  end

  def preview_rule_changes
    on CmRequisiteRules do |page|
      begin
        page.preview_change('')
      rescue Exception => e
        begin
          page.preview_change('node_0_parent_')
        rescue Exception => e
          page.preview_change('node_2_parent_')
        end
      end
    end
  end


  def rule_advanced_search(field, code, index)
    on CmRequisiteAdvancedSearchPage do |page|
      if field == "course title"
        page.search_course_title.fit code
      elsif field == "course code"
        page.search_course_code.fit code
      elsif field == "description"
        page.adv_plain_text_description.fit code
      end
      page.course_search
      sleep 5
      page.select_result(index)
    end
  end

  def click_search_link( regex)
    on CmRequisiteRules do |page|
      elements = page.edit_tree_section.elements( :tag_name, 'a')
      elements.each do |elem|
        if elem.text == "Advanced Search" && page.edit_tree_section.a( id: elem.id).attribute_value('data-submit_data') =~ regex
          page.edit_tree_section.a(id: elem.id).click
          break
        end
      end
      raise "co requisites click_search_link: link not found for: #{regex}"
    end
  end

end
