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
        # Active Dates
        :start_term, :pilot_course, :end_term,
        # Authors & Collaborators
        :author_name_search, :author_name, :author_permission, :action_request, :author_notation



  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        #REQUIRED
        #COURSE INFORMATION
          proposal_title: 'test proposal title',
          course_title: 'test course title',
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
          #AUTHORS & COLLABORATORS
          author_name_search: 'user1', author_name: 'One, User (user1)', author_permission: ['Edit, Comments, View', 'Comments, View', 'View'].sample, action_request: 'FYI', author_notation: :set

    }
    set_options(defaults.merge(opts))

    random_checkbox @scheduling_term
    random_radio(@final_exam_status)
    random_checkbox(@campus_location)
    random_checkbox(@assessment_scale)
  end

  def create

    on KradRice do |page|
      if page.krad_curriculum_management_element.exists?
      page.krad_curriculum_management
      end
    end

    on(KradCurriculum).create_a_course

    on KradCourseInformation do |page|
      fill_out page, :proposal_title, :course_title
      page.expand_course_listing_section
      page.add_a_version_code unless @version_code_code.nil? and @version_code_title.nil?

      page.subject_code.fit @subject_code
      page.auto_lookup @subject_code unless @subject_code.nil?

      fill_out page, :version_code_code, :version_code_title
      #fill_out page, :description_rationale, :proposal_rationale, :course_number

      page.save_and_continue
    end

    on(KradCurriculum).authors_collaborators
    on KradAuthorsCollaborators do |page|
      page.advanced_search
    end


end  #create


  def KradCourseProposalRequired
    on(KradCurriculum).course_information
    on KradCourseInformation do |page|
      page.expand_course_listing_section
      fill_out page, :description_rationale, :proposal_rationale, :course_number, :version_code_code, :version_code_title
      page.save_and_continue
    end

    on KradGovernance do |page|
      fill_out page, :curriculum_oversight
      page.add_oversight unless @curriculum_oversight.nil?
      page.save_and_continue
    end

    on KradCourseLogistics do |page|
      page.add_outcome unless @outcome_type.nil?
      # outcome_type needs to be done first because of page loading
      fill_out page, :outcome_type
      fill_out page, :assessment_a_f, :assessment_notation, :assessment_letter, :assessment_pass_fail,
               :assessment_percentage, :assessment_satisfactory
      set_outcome_type
      page.add_additional_format
      page.add_activity

      #Test to check that only one exam can be checked
      page.exam_alternate.set
      page.exam_standard.set

      fill_out page, :activity_type, :exam_standard, :exam_alternate, :exam_none
      # This 'unless' is because Standard Exam does not have rationale
      page.final_exam_rationale.fit @final_exam_rationale unless page.exam_standard.set?
      page.save_and_continue
    end

    on(KradCurriculum).active_dates
    on KradActiveDates do |page|
      page.start_term.fit @start_term
      page.pilot_course.fit @pilot_course
      page.loading_wait
      # SPECIAL:: Need this second start_term because end_term not immediately selectable after checkbox is selected
      #page.start_term.fit @start_term
      sleep 1
      page.end_term.fit @end_term
      page.save_and_continue
    end
  end # required

  def KradCourseProposalNonrequired
    on(KradCurriculum).course_information
    on KradCourseInformation do |page|
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

      if instructor_adding_method == 'auto_lookup_instructor_name'
        page.instructor_name.fit @instructor_last_name
        page.auto_lookup @instructor_display_name unless @instructor_display_name.nil?
      end

      page.instructor_add unless @instructor_last_name.nil?


      page.save_and_continue
    end

    on KradGovernance do |page|
      fill_out page, :location_all, :location_extended, :location_north, :location_south

      admin_org_adding_method = ['advanced', 'auto_lookup'].sample
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
      #page.scheduling_term(@scheduling_term).set unless @scheduling_term.nil?
      fill_out page, :term_any, :term_fall, :term_spring, :term_summer,
               :audit, :pass_fail_transcript_grade,
               :duration_type, :duration_count,
               :activity_contacted_hours, :activity_class_size,
               :activity_duration_count, :activity_frequency, :activity_duration_type
      page.save_and_continue
    end

    on(KradCurriculum).authors_collaborators
    on KradAuthorsCollaborators do |page|
      # Need to use auto lookup because type in removes parentheses from text field
      page.author_name.fit @author_name_search
      page.auto_lookup @author_name

      fill_out page, :author_permission, :action_request, :author_notation
      page.add_author
      page.save_and_continue
    end

  end # non-required


    def verify_text_field(page, *fields)
      fields.shuffle.each do |field|
        lmnt = page.send(*[field].compact)
        var = instance_variable_get "@#{field}"
        lmnt.value.should == (var)
      end
    end

  def handle_alert(page, choose_option = 'ok')
    #ok or close
    if page.alert.exists?
      if choose_option == 'ok'
        page.alert.ok
      else
        page.alert.close
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
    set(pass_in_an_array.sample, :set)
  end
  alias_method :random_radio, :random_checkbox

end #object class


