class KradCourseProposalObject

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  # Course Information, Governance, Course Logistics, Active Dates completed
  attr_accessor :proposal_title, :course_title,
        :transcript_title, :subject_code, :course_number,
        :course_listing_subject, :course_listing_number,
        :joint_offering_number, :version_code_code, :version_code_title,
        :instructor, :instructor_first_name, :instructor_last_name, :instructor_username, :instructor_display_name,
        :description_rationale, :proposal_rationale,

        :instructor_adding_method, :joint_offering_adding_data,
        :joint_offering_name, :joint_offering_description, :joint_offering_course_code,
        # Governance Page
        :camp_local,
        :campus_location, :curriculum_oversight, :administering_organization,
        :location_north, :location_south, :location_extended, :location_all,
        :administering_organization, :adv_admin_org_identifier,
        :adv_admin_org_name, :adv_admin_org_abbreviation, :adv_admin_org_name,
        :admin_org_adding_method,

  # Course Logistics
        :term_any, :term_fall, :term_spring, :term_summer,
        :assessment_scale, :final_exam_rationale,
        :exam_standard, :exam_alternate, :exam_none,
        :outcome_type, :outcome_value,
        :credit_value_max, :credit_value_min,
        :outcome_multiple, :outcome_multiple2, :outcome_credit_value, :outcome_credit_value_max,
        :outcome_credit_value_multiple, :outcome_credit_value_multiple2,
        :course_format_activity_type,
        :duration_type, :duration_count,
        :activity_type, :activity_duration_type, :activity_frequency,
        :activity_contacted_hours, :activity_duration_count, :activity_class_size,
        :audit, :pass_fail_transcript_grade,
        :assessment_a_f, :assessment_notation, :assessment_letter, :assessment_pass_fail, :assessment_percentage, :assessment_satisfactory,
        #Course Requisites
        :student_eligibility_rule, :add_eligibility_rule, :rule_adv_course_title, :rule_adv_course_code, :rule_adv_course_description_snip,

        :corequisiste_rule,:recommended_preparation_rule, :antirequisite_rule,
        :repeatable_for_credit_rule, :course_that_restricts_credits_rule,

        # Active Dates
        :start_term, :pilot_course, :end_term,
        # Authors & Collaborators
        :author_name_search, :author_username_search, :author_permission, :action_request,
        :author_notation,
        :author_name_method, :author_display_name


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        #REQUIRED
        #COURSE INFORMATION
          proposal_title: 'test proposal title ' + random_alphanums(5) + '' + random_alphanums(5),
          course_title: 'test course title' + random_alphanums(5) + '' + random_alphanums(5),
          subject_code: 'MATH',
          course_number: rand(100..999).to_s,
          version_code_code: 'A',
          version_code_title: 'TEST version code course title TEST',
          description_rationale: random_alphanums(200),
          proposal_rationale: random_alphanums(200),
          subject_code: 'MATH',
        #GOVERNANCE
          curriculum_oversight: 'CMNS-Mathematics',
        #COURSE LOGISTICS
          scheduling_term: [:term_any, :term_fall, :term_spring, :term_summer],
          assessment_scale: [:assessment_a_f, :assessment_notation, :assessment_letter, :assessment_pass_fail, :assessment_percentage, :assessment_satisfactory],
          final_exam_status: [:exam_standard, :exam_alternate, :exam_none],
          final_exam_rationale: random_alphanums(50),
          outcome_type: ['Fixed', 'Multiple', 'Range'].sample,
          outcome_value: rand(1..3).to_s,
          credit_value_min: rand(1..3).to_s,
          credit_value_max: rand(4..8).to_s,
          outcome_multiple: rand(1..3).to_s,
          outcome_multiple2: rand(4..7).to_s,
        #ACTIVE DATES
          start_term: 'Spring 1980', end_term: 'Fall 1980',
          pilot_course: :set,

        #NON REQUIRED
        #COURSE INFORMATION
          transcript_title: 'test '+random_alphanums(15),
          course_number: rand(100..999).to_s,
          course_listing_subject: 'FREN',
          course_listing_number: '888',
          joint_offering_number: 'HIST201',
          version_code_code: 'A',
          version_code_title: 'TEST200',
          instructor_display_name: 'SMITH, DAVID (s.davidb)',
          instructor_first_name: 'DAVID',
          instructor_last_name: 'SMITH',
          instructor_username: 's.davidb',

          instructor_adding_method: ['auto_lookup_instructor_name', 'adv_username', 'adv_name'].sample,
          joint_offering_adding_data: ['adv_given_name', 'adv_course_code', 'adv_plain_text', 'auto_lookup'].sample,

          joint_offering_name: 'Interpreting American History: From 1865 to the Present',
          joint_offering_description: 'The United States from the end of the Civil War to the present.',
          joint_offering_course_code: 'HIST201',

    #GOVERNANCE
          admin_org_adding_method: ['advanced', 'auto_lookup'].sample,
          administering_organization:  'Biological Sciences',
          campus_location: [:location_all, :location_extended, :location_north, :location_south],

          #BUG FOR IDENTIFIER
          # adv_admin_org_identifier: 'ORGID-BISI',

          adv_admin_org_name: 'Biological Sciences',
          adv_admin_org_abbreviation: 'BISI',

        #COURSE LOGISTICS
          duration_type: ['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
          duration_count: rand(1..9).to_s,
          activity_duration_type: ['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
          activity_type: ['Directed', 'Discussion', 'Experiential Learning/Other', 'Homework', 'Lab', 'Lecture', 'Tutorial', 'Web Discuss', 'Web Lecture'].sample,
          activity_frequency: ['per day', 'per month', 'per week'].sample,
          activity_contacted_hours: rand(1..9).to_s,
          activity_duration_count: rand(1..9).to_s,
          activity_class_size: rand(1..9).to_s,
          audit: :set, pass_fail_transcript_grade: :set,

          #COURSE REQUISITES

          add_eligibility_rule: ['text', 'advanced'].sample,
          rule_adv_course_title: 'American Jewish Experience', rule_adv_course_code: 'HIST106', rule_adv_course_description_snip: 'History of the Jews in America',
          rule_course_field: '',

          student_eligibility_rule: 'Must have successfully completed <course>',
          corequisiste_rule: 'Must be concurrently enrolled in <course>',
          recommended_preparation_rule: 'Must have successfully completed <course>',
          antirequisite_rule: 'Must not have successfully completed <course>',
          repeatable_for_credit_rule: 'May be repeated for a maximum of <n> credits',
          course_that_restricts_credits_rule: 'Must not have successfully completed <course>',

          # TODO:: Discuss with Abe how to move this out of here to clean up code.

          #student_eligibility_rule: ['Must have successfully completed <course>', 'Must have successfully completed all courses from <courses>',
          #                           'Must have successfully completed a minimum of <n> courses from <courses>', 'Must have successfully completed a minimum of <n> credits from <courses>',
          #                           'Must have successfully completed a minimum of <n> credits from courses in the <org>', 'Must have earned a minimum of <n> total credits',
          #                           'Must have earned a minimum cumulative GPA of <GPA>', 'Permission of instructor required', 'Permission of <administering org> required',
          #                           'Must have been admitted to the <program> program', 'Must have been admitted to a program offered by <org>',
          #                           'Must be admitted to any program offered at the course campus location', 'Students admitted to <program> may take no more than <n> courses in the <org> in <duration><durationType>',
          #                           'Must have earned a minimum GPA of <GPA> in <courses>', 'Must have earned a minimum grade of <gradeType> <grade> in <courses>',
          #                           'Must successfully complete a minimum of <n> courses from <courses> with a minimum grade of <gradeType> <grade>', 'Must have earned a minimum cumulative GPA of <GPA> in <duration><durationType>',
          #                           'Student must be a member of <population>', 'Must successfully complete no more than <n> credits from <courses>', 'Must have successfully completed no more than <n> courses from <courses>',
          #                           'Must not have earned a grade of <gradeType> <grade> or higher in <courses>', 'Must not have been admitted to the <program> program',
          #                           'Students not admitted to <program> may take no more than <n> courses in the <org> in <duration><durationType>', 'Must have successfully completed <course> as of <term>',
          #                           'Must have successfully completed <course> prior to <term>', 'Must have successfully completed <course> between <term1> and <term2>', 'Free Form Text'].sample,
          #
          #corequisiste_rule: ['Must be concurrently enrolled in <course>', 'Must be concurrently enrolled in a minimum of <n> courses from <courses>',
          #              'Must be concurrently enrolled in all courses from <courses>', 'Must have earned a minimum of <n> total credits',
          #              'Must have earned a minimum cumulative GPA of <GPA>', 'Free Form Text'].sample,
          #
          #recommended_preparation_rule: ['Must have successfully completed <course>', 'Must have successfully completed all courses from <courses>',
          #                         'Must have successfully completed a minimum of <n> courses from <courses>', 'Must have successfully completed a minimum of <n> credits from <courses>',
          #                         'Must have successfully completed a minimum of <n> credits from courses in the <org>', 'Must have earned a minimum of <n> total credits',
          #                         'Must have earned a minimum cumulative GPA of <GPA>', 'Must have been admitted to the <program> program', 'Must have been admitted to a program offered by <org>',
          #                         'Must be admitted to any program offered at the course campus location', 'Must have earned a minimum GPA of <GPA> in <courses>',
          #                         'Must have earned a minimum grade of <gradeType> <grade> in <courses>', 'Must successfully complete a minimum of <n> courses from <courses> with a minimum grade of <gradeType> <grade>',
          #                         'Must have earned a minimum cumulative GPA of <GPA> in <duration><durationType>', 'Student must be a member of <population>',
          #                         'Must successfully complete no more than <n> credits from <courses>', 'Must have successfully completed no more than <n> courses from <courses>',
          #                         'Must have successfully completed <course> as of <term>', 'Must have successfully completed <course> prior to <term>',
          #                         'Must have successfully completed <course> between <term1> and <term2>', 'Free Form Text'].sample,
          #
          #antirequisite_rule: ['Must not have successfully completed <course>', 'Must not have successfully completed any courses from <courses>',
          #               'Must not have successfully completed any credits from <courses>', 'Must successfully complete no more than <n> credits from <courses>',
          #               'Must not have earned a grade of <gradeType> <grade> or higher in <courses>', 'Free Form Text'].sample,


        #AUTHORS & COLLABORATORS
          author_name_method: ['auto_lookup', 'advanced_name', 'advanced_username'].sample,
          author_name_search: 'User',author_username_search: 'user1', author_display_name: 'One, User (user1)',
          author_permission: ['Edit, Comments, View', 'Comments, View', 'View'].sample, action_request: 'FYI',
          author_notation: :set

    }
    set_options(defaults.merge(opts))

    random_checkbox @scheduling_term
    random_radio(@final_exam_status)
    random_checkbox(@campus_location)
    random_checkbox(@assessment_scale)
  end

  def create

@bug_fixed = true

    on KradRice do |page|
      if page.krad_curriculum_management_element.exists?
        page.krad_curriculum_management
      end
    end

    on(KradCurriculum).create_a_course

if @bug_fixed == true

    on KradCourseInformation do |page|
      page.course_information unless page.current_page('Course Information').exists?

      page.expand_course_listing_section
      page.add_a_version_code unless @version_code_code.nil? and @version_code_title.nil?
      page.subject_code.fit @subject_code
      page.auto_lookup @subject_code unless @subject_code.nil?

      fill_out page, :proposal_title, :course_title, :version_code_code, :version_code_title

      page.save_and_continue
    end

end #Bug_Fixed?

  end  #create

  def KradCourseProposalRequired

if @bug_fixed == true

    on KradCourseInformation do |page|
      page.course_information unless page.current_page('Course Information').exists?

      page.expand_course_listing_section
      fill_out page, :description_rationale, :proposal_rationale, :course_number, :version_code_code, :version_code_title
      page.save_and_continue
    end

    on KradGovernance do |page|
      page.governance unless page.current_page('Governance').exists?

      fill_out page, :curriculum_oversight
      page.add_oversight unless @curriculum_oversight.nil?
      page.save_and_continue
    end

    on KradCourseLogistics do |page|
      page.course_logistics unless page.current_page('Course Logistics').exists?


      page.loading_wait
      page.add_outcome unless @outcome_type.nil?
      # outcome_type needs to be done first because of page loading
      fill_out page, :outcome_type
      fill_out page,
               :assessment_a_f, :assessment_notation, :assessment_letter, :assessment_pass_fail,
               :assessment_percentage, :assessment_satisfactory

      sleep 1
      set_outcome_type
      page.add_additional_format
      page.add_activity

      #Test to check that only one exam can be checked
      page.exam_alternate.set
      page.exam_standard.set

      fill_out page, :activity_type, :exam_standard, :exam_alternate, :exam_none
      # SPECIAL CASE: This 'UNLESS' is required for 'Standard Exam' which, does not have rationale
      page.final_exam_rationale.fit @final_exam_rationale unless page.exam_standard.set?
      page.save_and_continue
    end


    on KradActiveDates do |page|
      page.active_dates unless page.current_page('Active Dates').exists?

      page.start_term.fit @start_term
      page.pilot_course.fit @pilot_course
      page.loading_wait
      # SPECIAL:: Need this second start_term because end_term not immediately selectable after checkbox is selected
      #page.start_term.fit @start_term
      sleep 1
      page.end_term.fit @end_term
      page.save_and_continue
    end

end #Bug_fixed?

  end # required proposal

  def KradCourseProposalNonrequired

if @bug_fixed == true

    on KradCourseInformation do |page|
      page.course_information unless page.current_page('Course Information').exists?

      page.loading_wait
      page.expand_course_listing_section
      page.add_another_course_listing unless @course_listing_subject.nil? and @course_listing_number.nil?
      #page.add_another_course unless @joint_offering_number.nil?

      fill_out page, :course_listing_number, :transcript_title

      page.course_listing_subject.fit @course_listing_subject
      page.auto_lookup @course_listing_subject unless @course_listing_subject.nil?

      if @joint_offering_adding_data == 'auto_lookup'
        page.add_another_course
        page.joint_offering_number.fit @joint_offering_number
        page.auto_lookup @joint_offering_number unless @joint_offering_number.nil?
      end

      if @joint_offering_adding_data == 'adv_given_name' or @joint_offering_adding_data == 'adv_course_code' or @joint_offering_adding_data == 'adv_plain_text'
        page.add_another_course
        page.joint_offering_advanced_search
        page.adv_given_name.wait_until_present
        page.adv_course_code.fit @joint_offering_course_code if @joint_offering_adding_data == 'adv_course_code'
        page.adv_given_name.fit @joint_offering_name if @joint_offering_adding_data == 'adv_given_name'
        page.adv_plain_text_description.fit @joint_offering_description if @joint_offering_adding_data == 'adv_plain_text'
        page.adv_search
        page.adv_return_value @joint_offering_course_code
      end

      if instructor_adding_method == 'adv_name' or instructor_adding_method == 'adv_username'
        page.instructor_advanced_search
        page.adv_name.fit @instructor_last_name if instructor_adding_method == 'adv_name'
        page.adv_username.fit @instructor_username if instructor_adding_method == 'adv_username'
        page.adv_search
        page.adv_return_value_instructor @instructor_display_name
      end

      if instructor_adding_method == 'auto_lookup'
        page.instructor_name.fit @instructor_last_name
        page.auto_lookup @instructor_display_name unless @instructor_display_name.nil?
      end

      page.instructor_add unless @instructor_last_name.nil?
      page.save_and_continue
    end

    on KradGovernance do |page|
      page.governance unless page.current_page('Governance').exists?

      fill_out page, :location_all, :location_extended, :location_north, :location_south

      if admin_org_adding_method == 'auto_lookup'
        page.administering_organization.fit @administering_organization
        #TODO: uncomment this when bug KSCM-1204 is fixed for auto lookup on administering org text field
        #page.auto_lookup @administering_organization unless @administering_organization.nil?
        page.organization_add unless @administering_organization.nil?
      end

      if admin_org_adding_method == 'advanced'
        page.adv_search_admin_org
        page.adv_identifier.fit @adv_admin_org_identifier
        page.adv_org_name.fit @adv_admin_org_name
        page.adv_abbreviation.fit @adv_admin_org_abbreviation
        page.adv_search
        page.adv_admin_org_return_value(@adv_admin_org_name, @adv_admin_org_abbreviation)
        page.organization_add unless @administering_organization.nil?
      end

      page.save_and_continue
    end

    on KradCourseLogistics do |page|
      page.course_logistics unless page.current_page('Course Logistics').exists?

      #page.scheduling_term(@scheduling_term).set unless @scheduling_term.nil?
      fill_out page, :term_any, :term_fall, :term_spring, :term_summer,
               :audit, :pass_fail_transcript_grade,
               :duration_type, :duration_count,
               :activity_contacted_hours, :activity_class_size,
               :activity_duration_count, :activity_frequency, :activity_duration_type
      page.save_and_continue
    end

    on KradLearningObjectives do |page|
      page.learning_objectives unless page.current_page('Learning Objectives').exists?

      # TODO:: NEED TO MAKE TESTS FOR THIS PAGE

      page.save_and_continue
    end

end #bug_fixed?

# THIS CODE IS IN PROGRESS
# THIS CODE IS IN PROGRESS
# THIS CODE IS IN PROGRESS

    on KradCourseRequisites do |page|
      page.course_requisites unless page.current_page('Course Requisites').exists?

      page.course_requisites
      page.expand_all_rule_sections


      #STUDENT ELIGIBILITY
      page.add_rule_student_eligibility
      page.add_statement
      page.rule_statement_option.fit @student_eligibility_rule
      #Complicated IF statement required for random pick.

      if  @student_eligibility_rule == 'Must have successfully completed <course>'
        # Enter text
        if @add_eligibility_rule == 'text'
          page.rule_course_field.fit @rule_adv_course_code
        end

        if @add_eligibility_rule == 'advanced'
          page.advanced_search
          #pick one field
          page.adv_course_title.fit @rule_adv_course_title
          page.adv_course_code.fit @rule_adv_course_code
          page.adv_phrase.fit @rule_adv_course_description_snip
          page.adv_search
          #number is the column number 1 = course title, 2 = Course Code, 4 = Description
          return_search_result(@rule_adv_course_code, 2)
        end
      end

      page.preview_change
      page.update_rule

      #COREQUISITE
      page.expand_all_rule_sections
      page.add_rule_corequisite
      page.add_statement
      page.rule_statement_option.fit @corequisiste_rule

      page.rule_course_field.fit @rule_adv_course_code

      # Add Advanced alt

      page.preview_change
      page.update_rule

      #RECOMMENDED PREPARATION
      page.expand_all_rule_sections
      page.add_rule_recommended_prep
      page.add_statement

      page.rule_statement_option.fit @recommended_preparation_rule
      if @recommended_preparation_rule == 'Must have successfully completed <course>'
        page.rule_course_field.fit @rule_adv_course_code

      end
      page.preview_change
      page.update_rule


      #ANTIREQUISITE
      page.expand_all_rule_sections
      page.add_rule_antirequisite
      page.add_statement
      page.rule_statement_option.fit @antirequisite_rule
      if @antirequisite_rule == 'Must not have successfully completed <course>'
        page.rule_course_field.fit @rule_adv_course_code

      end
      page.preview_change
      page.update_rule

      #REPEATABLE FOR CREDIT
      page.expand_all_rule_sections
      page.add_rule_repeatable_for_credits
      page.add_statement
      page.rule_statement_option.fit @repeatable_for_credit_rule
      if @repeatable_for_credit_rule == 'May be repeated for a maximum of <n> credits'

      end
      page.preview_change
      page.update_rule

      #COURSE THAT RESTRICTS CREDIT
      page.expand_all_rule_sections
      page.add_rule_restricts_credits
      page.add_statement
      page.rule_statement_option.fit @course_that_restricts_credits_rule
      if @course_that_restricts_credits_rule == 'Must not have successfully completed <course>'

      end
      page.preview_change
      page.update_rule


      page.save_and_continue
    end

# END IN PROGRESS
# END IN PROGRESS
# END IN PROGRESS


    on KradAuthorsCollaborators do |page|
      page.authors_collaborators unless page.current_page('Authors Collaborators').exists?

      # Need to use auto lookup because type in removes parentheses from text field
      if author_name_method == 'auto_lookup'
        page.author_name.fit @author_name_search
        page.auto_lookup @author_display_name
      end

      if author_name_method == 'advanced_name' or author_name_method == 'advanced_username'
        page.advanced_search
        page.adv_name.fit @author_name_search if author_name_method == 'advanced_name'
        page.adv_username_capD.fit @author_username_search if author_name_method == 'advanced_username'
        page.adv_search
        page.adv_return_value_name @author_display_name
      end

      fill_out page, :author_permission, :action_request, :author_notation
      page.add_author
      page.save_and_continue
    end

  end # non-required







  ## NOT USED AT THIS TIME For Step Def
  #  def verify_text_field(page, *fields)
  #    fields.shuffle.each do |field|
  #      lmnt = page.send(*[field].compact)
  #      var = instance_variable_get "@#{field}"
  #      lmnt.value.should == (var)
  #    end
  #  end
  #
  #def handle_alert(page, choose_option = 'ok')
  #  #ok or close
  #  if page.alert.exists?
  #    if choose_option == 'ok'
  #      page.alert.ok
  #    else
  #      page.alert.close
  #    end
  #  end
  #end



  # Selects the Return Value link on advanced search results when column matches the variable
  def return_search_result(value_to_find, col_number=3)
    search_results_table.rows.each do |row|
      if row.cells[col_number].text == value_to_find
        row.cells[0].link(text: 'return value').click
        break
      end
    end
  end


  #-----
  private
  #-----

  def set_outcome_type(outcome_level='0')
    on KradCourseLogistics do |page|
      page.credit_value(outcome_level).set @outcome_value if @outcome_type == 'Fixed'
      page.credit_value_max(outcome_level).set credit_value_max if @outcome_type == 'Range'
      page.credit_value_min(outcome_level).set credit_value_min if @outcome_type == 'Range'

      #TODO:: Find a way to make type Multiple work with the outcome_level variable for multiple outcome types
      if @outcome_type == 'Multiple'
        page.credit_value_multiple.fit @outcome_multiple
        page.outcome_add_multiple_btn
        page.credit_value_multiple.fit @outcome_multiple2
        page.outcome_add_multiple_btn
      end
    end
  end

  def random_checkbox(pass_in_an_array)
    set(pass_in_an_array.sample, :set)  unless pass_in_an_array.nil?
  end
  alias_method :random_radio, :random_checkbox

end #object class


