#-----
# S1
#-----
Given /^I create a course proposal in krad$/ do
  @course_proposal = create KradCourseProposalObject
end

Then /^I should see data in the proposal title on course information$/ do
  on(KradCurriculum).course_information

  on KradCourseInformation do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
  end
end

And /^I should see data in the course title on course information$/ do
  on(KradCurriculum).course_information
  on KradCourseInformation do |page|
    page.course_title.value.should == @course_proposal.course_title
  end
end

#-----
# S2
#-----
Given /^I complete require fields on the course proposal$/ do
  @course_proposal.KradCourseProposalRequired
end

Then /^I should see data in required fields for the course proposal$/ do
  on(KradCurriculum).course_information

  on KradCourseInformation do |page|
    page.subject_code.value.should == @course_proposal.subject_code
    page.course_number.value.should == @course_proposal.course_number

    page.version_code_code.value.should == @course_proposal.version_code_code
    page.version_code_title.value.should == @course_proposal.version_code_title

    page.description_rationale.value.should == @course_proposal.description_rationale
    page.proposal_rationale.value.should == @course_proposal.proposal_rationale
  end

  on(KradCurriculum).governance
  on KradGovernance do |page|
    page.curriculum_oversight_when_added(@course_proposal.curriculum_oversight).should be_present
  end

  on(KradCurriculum).course_logistics
  on KradCourseLogistics do |page|

    page.exam_standard.should be_checked if @course_proposal.exam_standard == 'set'
    page.exam_alternate.should be_checked if @course_proposal.exam_alternate == 'set'
    page.exam_none.should be_checked if @course_proposal.exam_none == 'set'

    page.final_exam_rationale.value.should == @course_proposal.final_exam_rationale unless page.exam_standard.set?

    page.credit_value.value.should == @course_proposal.outcome_value if @course_proposal.outcome_type == 'Fixed'

    page.credit_value_multiple('0').value.should == @course_proposal.outcome_multiple if @course_proposal.outcome_type == 'Multiple'
    page.credit_value_multiple('1').value.should == @course_proposal.outcome_multiple2 if @course_proposal.outcome_type == 'Multiple'

    page.credit_value_min.value.should == @course_proposal.credit_value_min if @course_proposal.outcome_type == "Range"
    page.credit_value_max.value.should == @course_proposal.credit_value_max if @course_proposal.outcome_type == "Range"

    page.activity_type.selected?(@course_proposal.activity_type).should == true

    page.assessment_a_f.should be_checked if @course_proposal.assessment_a_f == 'set'
    page.assessment_notation.should be_checked if @course_proposal.assessment_notation == 'set'
    page.assessment_letter.should be_checked if @course_proposal.assessment_letter == 'set'
    page.assessment_pass_fail.should be_checked if @course_proposal.assessment_pass_fail == 'set'
    page.assessment_percentage.should be_checked if @course_proposal.assessment_percentage== 'set'
    page.assessment_satisfactory.should be_checked if @course_proposal.assessment_satisfactory == 'set'
  end

  on(KradCurriculum).active_dates
  on KradActiveDates do |page|
    page.start_term.selected?(@course_proposal.start_term).should == true unless @course_proposal.start_term.nil?
    page.pilot_course.should be_checked
    page.end_term.selected?(@course_proposal.end_term).should == true unless @course_proposal.end_term.nil?
  end
end

#-----
# S3
#-----
Given /^I complete non-required fields on the course proposal$/ do
  @course_proposal.KradCourseProposalNonrequired
end

Then /^I should see data in all non required fields for the course proposal$/ do
  on(KradCurriculum).course_information
  on KradCourseInformation do |page|
    page.transcript_title.value.should == @course_proposal.transcript_title

    #page.subject_code.value.should == @course_proposal.subject_code
    #@course_proposal.verify_text_field(page, 'course_listing_subject', 'course_listing_number', 'joint_offering_number')
    page.course_listing_subject.value.should == @course_proposal.course_listing_subject
    page.course_listing_number.value.should == @course_proposal.course_listing_number
    page.joint_offering_number.value.should == @course_proposal.joint_offering_number
    page.added_instructor_name.value.should == @course_proposal.instructor_display_name
  end

  on(KradCurriculum).governance
  on KradGovernance do |page|
    #@course_proposal.verify_text_field(page, 'added_administering_organization' )
    page.added_administering_organization.value.should == @course_proposal.administering_organization unless @course_proposal.administering_organization.nil?
    page.location_north.should be_checked if @course_proposal.location_north == 'set'
    page.location_south.should be_checked if @course_proposal.location_south == 'set'
    page.location_extended.should be_checked if @course_proposal.location_extended == 'set'
    page.location_all.should be_checked if @course_proposal.location_all == 'set'
  end

  on(KradCurriculum).course_logistics
  on KradCourseLogistics do |page|
    page.term_any.should be_checked if @course_proposal.term_any == 'set'
    page.term_fall.should be_checked if @course_proposal.term_fall == 'set'
    page.term_spring.should be_checked if @course_proposal.term_spring == 'set'
    page.term_summer.should be_checked if @course_proposal.term_summer == 'set'

    page.duration_count.value.should == @course_proposal.duration_count unless @course_proposal.duration_count.nil?
    page.duration_type.selected?(@course_proposal.duration_type).should == true unless @course_proposal.duration_type.nil?

    page.audit.should be_checked
    page.pass_fail_transcript_grade.should be_checked

    #@course_proposal.verify_text_field(page, 'activity_contacted_hours', 'activity_duration_count', 'activity_class_size' )

    page.activity_contacted_hours.value.should == @course_proposal.activity_contacted_hours
    page.activity_duration_count.value.should == @course_proposal.activity_duration_count
    page.activity_class_size.value.should == @course_proposal.activity_class_size
    page.activity_frequency.selected?(@course_proposal.activity_frequency).should == true unless @course_proposal.activity_frequency.nil?
    page.activity_duration_type.selected?(@course_proposal.activity_duration_type).should == true unless @course_proposal.activity_duration_type.nil?
  end

  on(KradCurriculum).authors_collaborators
  on KradAuthorsCollaborators do |page|
    page.added_author_information('edit').should be_present if @course_proposal.author_permission == 'Edit, Comments, View'
    page.added_author_information('comment').should be_present if @course_proposal.author_permission == 'Comments, View'
    page.added_author_information('view').should be_present if @course_proposal.author_permission == 'View'

    page.added_author_information('fyi').should be_present if @course_proposal.action_request == 'FYI'
    page.added_author_information('false').should be_present if @course_proposal.author_notation.nil?
    page.added_author_information('true').should be_present unless @course_proposal.author_notation.nil?

    page.added_author_information(@course_proposal.author_display_name).should be_present
  end
end


#-----
# S4
#-----
When /^I complete all fields on the course proposal with advanced search$/ do
  @course_proposal  = make KradCourseProposalObject, joint_offering_adding_data: ['adv_given_name', 'adv_course_code', 'adv_plain_text'].sample,
                           instructor_adding_method: ['adv_username', 'adv_name'].sample,
                           admin_org_adding_method: 'advanced',
                           author_name_method: ['advanced_name', 'advanced_username'].sample

  @course_proposal.KradCourseProposalRequired
  @course_proposal.KradCourseProposalNonrequired
end


#-----
# S5
#-----

When /^I complete all fields on the course proposal with auto\-lookup$/ do
  @course_proposal  = make KradCourseProposalObject, instructor_adding_method: 'auto_lookup',
                           joint_offering_adding_data: 'auto_lookup',
                           admin_org_adding_method: 'auto_lookup',
                           author_name_method: 'auto_lookup'

  @course_proposal.KradCourseProposalRequired
  @course_proposal.KradCourseProposalNonrequired
end

