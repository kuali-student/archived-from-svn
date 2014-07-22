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
    #$section = opts[:requisite_type]
    case @requisite_type
      when "Student Eligibility & Prerequisite"
        adding_rule_student_eligibility# :eligibility_rule_list => opts[:eligibility_rule_list],  :requisite_type=>opts[:requisite_type]
      when "Corequisite"
        adding_rule_corequisite
      when "Recommended Preparation"
        adding_rule_recommended_preparation_rule# :eligibility_rule_list => opts[:eligibility_rule_list],  :requisite_type=>opts[:requisite_type]
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
    on CmCourseRequisite do |rule_page|
      rule_page.edit_rule_student_eligibility :logic_operator => opts[:logic_operator],
                                              :left_group_node => opts[:left_group_node],
                                              :right_group_node => opts[:right_group_node] if opts[:requisite_type] == REQUISITE_TYPE_PREREQUISITE
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
      #STUDENT ELIGIBILITY #A,G,M,S
      begin
        page.edit_rule('A')
      rescue Exception => e
        begin
          page.edit_rule('G')
        rescue Exception => e
          begin
            page.edit_rule('M')
          rescue Exception => e
            begin
              page.edit_rule('S')
            rescue Exception => e
              page.edit_rule('Y')
            end
          end
        end
      end
      edit_A_rule :left_group_node => opts[:left_group_node] unless opts[:left_group_node].nil?
      edit_B_rule :right_group_node => opts[:right_group_node] unless opts[:right_group_node].nil?
      edit_operator :logic_operator => opts[:logic_operator] unless opts[:logic_operator].nil?

      update_adding_rules
    end
  end

  def edit_A_rule (opts={})
    on CmRequisiteRules do |page|
      page.rule_a_element_link
      page.loading_wait
      page.edit_btn
      page.course_field.fit opts[:left_group_node].course
    end
    preview_rule_changes
  end

  def edit_B_rule (opts={})
    on CmRequisiteRules do |page|
      # add contents
    end
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
        page.add_rule('A')
      rescue Exception => e
        begin
          page.add_rule('G')
        rescue Exception => e
          begin
            page.add_rule('M')
          rescue Exception => e
            page.add_rule('S')
          end
        end
      end
      unless @rule_list.nil?
        @rule_list.each do |rule|
          #add_one_rule (item)
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
        page.add_rule('C')
      rescue Exception => e
        begin
          page.add_rule('I')
        rescue Exception => e
          begin
            page.add_rule('O')
          rescue Exception => e
            page.add_rule('U')
          end
        end
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

  def add_one_rule (requisite_rule)
    on CmRequisiteRules do |page|

      page.add_btn
      page.loading_wait
      begin
        page.rule_statement_option('').fit requisite_rule.rule
      rescue Exception => e
        page.rule_statement_option('node_2_parent_').fit requisite_rule.rule
      end

      page.loading_wait

      if  requisite_rule.rule == 'Must have successfully completed <course>'
        requisite_rule.complete_rule_text = requisite_rule.rule.sub('<course>', requisite_rule.course)

        # Enter text
        if requisite_rule.add_method == 'text'
          puts 'student text'
          page.course_field.fit requisite_rule.course
        end

        if requisite_rule.add_method == 'advanced'
          puts 'student advanced'
          page.advanced_search
          #pick one field
          page.adv_course_title.fit requisite_rule.search_title
          page.adv_course_code_rule.fit requisite_rule.course
          page.adv_plain_text_description_rule.fit requisite_rule.search_phrase
          page.adv_search
          #number is the column number 1 = course title, 2 = Course Code, 4 = Description
          return_search_result(requisite_rule.course, 2)
        end
      end

      if requisite_rule.rule == 'Must successfully complete a minimum of <n> courses from <courses> with a minimum grade of <gradeType> <grade>'

        #enter  Number of Courses:
        page.integer_field.fit requisite_rule.completed_course_number

        #pick the courses, dynamic course ranges, or Course sets.
        page.multi_course_dropdown.fit requisite_rule.course_combination_type

        $i = 0
        $num = requisite_rule.completed_course_number
        while $i < $num do
          # Enter course Code text
          if requisite_rule.add_method == 'text'
            puts 'course Code text'
            page.course_field.fit requisite_rule.course
          end

          if requisite_rule.add_method == 'advanced'
            puts 'advanced search'
            page.advanced_search
            #pick one field
            page.adv_course_code_rule.fit requisite_rule.search_course_code
            page.adv_search
            #number is the column number 1 = course title, 2 = Course Code, 4 = Description
            page.select_course($i)
          end
          page.add_course_code
          $i +=1
        end

        page.completed
        page.loading_wait
        page.grade_dropdown.fit "A"

      end

      requisite_rule.preview_rule_changes
    end
  end

end
