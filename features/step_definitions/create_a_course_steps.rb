#-----
# S1
#-----
plus_minus = "A-F with Plus/Minus Grading"
completed_notation = "Accepts a completed notation"
letter = "Letter"
pass_fail= "Pass/Fail Grading"
percentage = "Percentage Grading 0-100%"
satisfactory = "Administrative Grade of Satisfactory"
standard_exam = "Standard Final Exam"
alternate_exam = "Alternate Final Assessment"
no_exam = "No Final Exam or Assessment"


When /^I create a course proposal$/ do
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false
end

When /^I create a course proposal from blank$/ do
  @course_proposal = create CmCourseProposalObject, :blank_proposal => true, :defer_save => true
end

Then /^I should see a blank course proposal$/ do
  on CmCourseInformation do |page|
    page.proposal_title.text.should == ""
    page.course_title.text.should == ""
  end
  end

And /^I cancel create a course$/ do
  @course_proposal.cancel_create_course
end

And /^I cancel the course proposal page$/ do
  @course_proposal.cancel_course_proposal
end

Then /^I should see CM Home$/ do
  on CmCurriculum do |page|
    page.cmcurriculum_header.exists?.should == true
  end
end


And /^I should see data in the course title on course information$/ do
  on CmCourseInformation do |page|
    page.course_information
    page.course_title.value.should == @course_proposal.course_title
  end
end

When /^I complete the required fields for save on the new course proposal$/ do
  @course_proposal = create CmCourseProposalObject
end

When /^I complete the required for save fields on the course proposal and save$/ do
  @course_proposal = create CmCourseProposalObject, :curriculum_review_process => "Yes",
                                                    :required_fields_only => false,
                                                    :submit_fields => [(make CmSubmitFieldsObject)],
                                                    :approve_fields => [(make CmApproveFieldsObject)]
end


When /^I complete the required fields on the course admin proposal$/ do
  @course_proposal = create CmCourseProposalObject, :required_fields_only => false,
                                                    :submit_fields => [(make CmSubmitFieldsObject)],
                                                    :approve_fields => [(make CmApproveFieldsObject)]

end


Then /^I should see data in required fields for the (.*?)$/ do |proposal_type|


  on(CmCourseInformation).course_information

  on CmCourseInformation do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
    page.growl_text.should == "Document was successfully saved."
    page.page_header_text.should == "#{@course_proposal.proposal_title} (Admin Proposal)" if proposal_type == "admin proposal"
    page.page_header_text.should == "#{@course_proposal.proposal_title} (Proposal)" if proposal_type == "course proposal"
    page.transcript_course_title.value.should == @course_proposal.approve_fields[0].transcript_course_title
    page.subject_code.value.should == @course_proposal.submit_fields[0].subject_code
    page.course_number.value.should == @course_proposal.approve_fields[0].course_number
    page.description_rationale.value.should == @course_proposal.submit_fields[0].description_rationale
    page.proposal_rationale.value.should == @course_proposal.submit_fields[0].proposal_rationale
  end

  on CmGovernance do |page|
    page.governance
    page.location_north.should be_checked if @course_proposal.approve_fields[0].location_north == :set
    page.location_south.should be_checked if @course_proposal.approve_fields[0].location_south == :set
    page.location_extended.should be_checked if @course_proposal.approve_fields[0].location_extended == :set
    page.location_all.should be_checked if @course_proposal.approve_fields[0].location_all == :set
    page.curriculum_oversight_when_added(@course_proposal.submit_fields[0].curriculum_oversight).should be_present
  end

  on CmCourseLogistics do |page|
    page.course_logistics

    #GRADES AND ASSESSMENTS
    page.assessment_a_f.should be_checked if @course_proposal.submit_fields[0].assessment_a_f == :set
    page.assessment_notation.should be_checked if @course_proposal.submit_fields[0].assessment_notation == :set
    page.assessment_letter.should be_checked if @course_proposal.submit_fields[0].assessment_letter == :set
    page.assessment_pass_fail.should be_checked if @course_proposal.submit_fields[0].assessment_pass_fail == :set
    page.assessment_percentage.should be_checked if @course_proposal.submit_fields[0].assessment_percentage== :set
    page.assessment_satisfactory.should be_checked if @course_proposal.submit_fields[0].assessment_satisfactory == :set

    #FINAL EXAM
    page.exam_standard.should be_checked unless @course_proposal.submit_fields[0].exam_standard.nil?
    page.exam_alternate.should be_checked  unless @course_proposal.submit_fields[0].exam_alternate.nil?
    page.exam_none.should be_checked unless @course_proposal.submit_fields[0].exam_none.nil?
    page.final_exam_rationale.value.should == @course_proposal.submit_fields[0].final_exam_rationale unless page.exam_standard.set?

    #OUTCOMES
    page.credit_value(0).value.should == "#{@course_proposal.submit_fields[0].outcome_list[0].credit_value}" if @course_proposal.submit_fields[0].outcome_list[0].outcome_type == "Fixed"
    page.credit_value(1).value.should == "#{@course_proposal.submit_fields[0].outcome_list[1].credit_value}" if @course_proposal.submit_fields[0].outcome_list[1].outcome_type == "Range"
    page.credit_value(2).value.should == "#{@course_proposal.submit_fields[0].outcome_list[2].credit_value}" if @course_proposal.submit_fields[0].outcome_list[2].outcome_type == "Multiple"


    #FORMATS
    page.type_added(1,1).selected?(@course_proposal.approve_fields[0].format_list[0].type).should == true
    page.contacted_hours_added(1,1).should == "#{@course_proposal.approve_fields[0].format_list[0].contacted_hours}"
    page.frequency_added(1,1).selected?(@course_proposal.approve_fields[0].format_list[0].contact_frequency).should == true
    page.duration_type_added(1,1).selected?(@course_proposal.approve_fields[0].format_list[0].duration_type).should == true
    page.duration_count_added(1,1).should == "#{@course_proposal.approve_fields[0].format_list[0].duration_count}"
    page.class_size_added(1,1).should == "#{@course_proposal.approve_fields[0].format_list[0].class_size}"



  end

  on CmActiveDates do |page|

    page.start_term.selected?(@course_proposal.submit_fields[0].start_term).should == true unless @course_proposal.submit_fields[0].start_term.nil?
    #page.pilot_course.should be_checked
    #page.end_term.selected?(@course_proposal.end_term).should == true unless @course_proposal.end_term.nil?
  end

end

When /^I am on the course information page and I click save progress without entering any values$/ do
  @course_proposal = create CmCourseProposalObject, :proposal_title => nil, :course_title => nil, :blank_proposal => true
end

And /^I click the save progress button$/ do

end

Then /^I should receive an error message about the proposal title and course title being required for save$/ do
 on CmCourseInformation do |page|
   #page.course_information
   page.proposal_title_error_state.exists?.should == true
   page.course_title_error_state.exists?.should == true
   page.growl_text.should include "The form contains errors. Please correct these errors and try again."
   page.page_validation_header.should include "This page has 2 errors"
 end
end

Then /^I should see data in required for save fields for the course proposal$/ do
  on CmCourseInformation do |page|
    page.course_information
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
    page.growl_text.should == "Document was successfully saved."
  end
end



And /^I should see data in required for save fields on the Review Proposal page$/ do
  on CmCourseInformation do |page|
    page.review_proposal
    page.loading_wait

  end
 
  on CmReviewProposal do |page|
    #puts "Original Proposal Title is #{page.proposal_title_review}"
    #puts "Original Course Title is #{page.course_title_review}"
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title
  end
end

And /^I edit the required for save fields and save$/ do
   @course_proposal.edit :proposal_title => "updated #{random_alphanums(10,'test proposal title ')}",
                         :course_title => "updated #{random_alphanums(10, 'test course title ')}"
end

And /^I edit the course proposal$/ do
  @course_proposal.edit   :proposal_title => "updated #{random_alphanums(10,'test proposal title ')}",
                          :course_title => "updated #{random_alphanums(10, 'test course title ')}",
                          :defer_save => true

  @course_proposal.submit_fields[0].edit :subject_code => "ENGL",
                                         :description_rationale => "updated #{random_alphanums(20, 'test description rationale ')}",
                                         :proposal_rationale => "updated #{random_alphanums(20, 'test proposal rationale ')}",
                                         :curriculum_oversight => '::random::',
                                         :assessment_scale => [:assessment_a_f, :assessment_notation, :assessment_letter, :assessment_pass_fail, :assessment_percentage, :assessment_satisfactory],
                                         :final_exam_type => [:exam_standard, :exam_alternate, :exam_none],
                                         :final_exam_rationale => "updated #{random_alphanums(10,'test final exam rationale ')}",
                                         :start_term => '::random::'



  @course_proposal.submit_fields[0].outcome_list[0].delete :defer_save => true, :outcome_level => 0
  @course_proposal.submit_fields[0].outcome_list[1].edit :credit_value=>"#{(1..4).to_a.sample},#{(5..9).to_a.sample}",
                                                         :outcome_level => 0,
                                                         :defer_save => true
  @course_proposal.submit_fields[0].add_outcome :outcome => (make CmOutcomeObject,
                                                :outcome_type => "Fixed",
                                                :outcome_level => 2,
                                                :credit_value => 5),
                                                :defer_save => true

  @course_proposal.approve_fields[0].edit :transcript_course_title => "updated #{random_alphanums(1,'123')}",
                                          :course_number => (100..999).to_a.sample,
                                          :campus_location => [:location_all, :location_extended, :location_north, :location_south],
                                          :defer_save => true


  @course_proposal.approve_fields[0].format_list[0].edit :format_level => 1,
                                       :activity_level => 1,
                                       :type => '::random::',
                                       :contacted_hours => (1..9).to_a.sample,
                                       :contact_frequency => '::random::',
                                       :duration_count => (1..9).to_a.sample,
                                       :duration_type => '::random::',
                                       :class_size => (1..9).to_a.sample

end

And /^I edit the course proposal for Faculty$/ do
  @course_proposal_faculty.edit :proposal_title => "updated #{random_alphanums(10,'test proposal title ')}", :course_title => "updated #{random_alphanums(10, 'test course title ')}"
end

Then /^I should not see the edit option in the search results for the Course Admin Proposal$/ do
  on FindProposalPage do |page|
    page.edit_proposal_element(@course_proposal.proposal_title).exists?.should == false
  end
end

And /^I should see the updated data on the Review proposal page$/ do
  on CmCourseInformation do |page|
    page.review_proposal
    page.loading_wait
  end

  on CmReviewProposal do |page|
    #COURSE INFORMATION SECTION
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title
    page.subject_code_review.should == "#{@course_proposal.submit_fields[0].subject_code}"
    page.description_review.should == "#{@course_proposal.submit_fields[0].description_rationale}"
    page.proposal_rationale_review.should == "#{@course_proposal.submit_fields[0].proposal_rationale}"

    #GOVERNANCE SECTION
    page.curriculum_oversight_review.should == @course_proposal.submit_fields[0].curriculum_oversight unless @course_proposal.submit_fields[0].curriculum_oversight.nil?

    #COURSE LOGISTICS SECTION
    #ASSESSMENT SCALE


    page.assessment_scale_review.should == plus_minus if @course_proposal.submit_fields[0].assessment_a_f == :set
    page.assessment_scale_review.should == completed_notation if @course_proposal.submit_fields[0].assessment_notation == :set
    page.assessment_scale_review.should == letter if @course_proposal.submit_fields[0].assessment_letter == :set
    page.assessment_scale_review.should == pass_fail if @course_proposal.submit_fields[0].assessment_pass_fail == :set
    page.assessment_scale_review.should == percentage if @course_proposal.submit_fields[0].assessment_percentage == :set
    page.assessment_scale_review.should == satisfactory if @course_proposal.submit_fields[0].assessment_satisfactory == :set

    #FINAL EXAM
    page.final_exam_status_review.should == standard_exam unless @course_proposal.submit_fields[0].exam_standard.nil?
    page.final_exam_status_review.should == alternate_exam unless @course_proposal.submit_fields[0].exam_alternate.nil?
    page.final_exam_status_review.should == no_exam unless @course_proposal.submit_fields[0].exam_none.nil?
    page.final_exam_rationale_review.should == @course_proposal.submit_fields[0].final_exam_rationale unless @course_proposal.submit_fields[0].exam_standard == :set

    #FIXED OUTCOME
    page.outcome_level_review(1).should == "Outcome #{@course_proposal.submit_fields[0].outcome_list[0].outcome_level.to_i+1}" unless @course_proposal.submit_fields[0].outcome_list[0].outcome_level.nil?
    page.outcome_type_review(1).should == "Fixed" unless @course_proposal.submit_fields[0].outcome_list[0].outcome_type.nil?
    page.outcome_credit_review(1) == "#{@course_proposal.submit_fields[0].outcome_list[0].credit_value}" unless @course_proposal.submit_fields[0].outcome_list[0].credit_value.nil?

    #RANGE OUTCOME
    page.outcome_level_review(2).should == "Outcome #{@course_proposal.submit_fields[0].outcome_list[1].outcome_level.to_i+1 }" unless @course_proposal.submit_fields[0].outcome_list[1].outcome_level.nil?
    page.outcome_type_review(2).should == "Multiple" unless @course_proposal.submit_fields[0].outcome_list[1].outcome_type.nil?
    page.outcome_credit_review(2) == "#{@course_proposal.submit_fields[0].outcome_list[1].credit_value}" unless @course_proposal.submit_fields[0].outcome_list[1].credit_value.nil?

    #MULTIPLE OUTCOME
    page.outcome_level_review(3).should == "Outcome #{@course_proposal.submit_fields[0].outcome_list[2].outcome_level.to_i+1}" unless @course_proposal.submit_fields[0].outcome_list[2].outcome_level.nil?
    page.outcome_type_review(3).should == "Range" unless @course_proposal.submit_fields[0].outcome_list[2].outcome_type.nil?
    page.outcome_credit_review(3) == "#{@course_proposal.submit_fields[0].outcome_list[2].credit_value}" unless @course_proposal.submit_fields[0].outcome_list[2].credit_value.nil?

    #ACTIVITY FORMAT
    page.format_level_review(@course_proposal.approve_fields[0].format_list[0].format_level).should include "#{@course_proposal.approve_fields[0].format_list[0].format_level}"
    page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].type}".gsub(/\s+/, "") unless @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
    page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "ExperientialLearningOROther" if @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
    page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contacted_hours}"
    page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contact_frequency}"
    page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_type}"
    page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_count}"
    page.activity_class_size_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should == "#{@course_proposal.approve_fields[0].format_list[0].class_size}"

    #ACTIVE DATES SECTION
    page.start_term_review.should == @course_proposal.submit_fields[0].start_term unless @course_proposal.submit_fields[0].start_term.nil?

  end

end


And /^I should see updated data on the Review proposal page$/ do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|
    #COURSE INFORMATION SECTION
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title
    page.transcript_course_title.should == @course_proposal.approve_fields[0].transcript_course_title
    page.subject_code_review.should == "#{@course_proposal.submit_fields[0].subject_code}"
    page.course_number_review.should == "#{@course_proposal.approve_fields[0].course_number}"
    page.description_review.should == "#{@course_proposal.submit_fields[0].description_rationale}"
    page.proposal_rationale_review.should == "#{@course_proposal.submit_fields[0].proposal_rationale}"

    #GOVERNANCE SECTION
    page.curriculum_oversight_review.should == @course_proposal.submit_fields[0].curriculum_oversight unless @course_proposal.submit_fields[0].curriculum_oversight.nil?

    #COURSE LOGISTICS SECTION
    #ASSESSMENT SCALE
    page.assessment_scale_review.should == plus_minus if @course_proposal.submit_fields[0].assessment_a_f == :set
    page.assessment_scale_review.should == completed_notation if @course_proposal.submit_fields[0].assessment_notation == :set
    page.assessment_scale_review.should == letter if @course_proposal.submit_fields[0].assessment_letter == :set
    page.assessment_scale_review.should == pass_fail if @course_proposal.submit_fields[0].assessment_pass_fail == :set
    page.assessment_scale_review.should == percentage if @course_proposal.submit_fields[0].assessment_percentage == :set
    page.assessment_scale_review.should == satisfactory if @course_proposal.submit_fields[0].assessment_satisfactory == :set

    #FINAL EXAM
    page.final_exam_status_review.should == standard_exam unless @course_proposal.submit_fields[0].exam_standard.nil?
    page.final_exam_status_review.should == alternate_exam unless @course_proposal.submit_fields[0].exam_alternate.nil?
    page.final_exam_status_review.should == no_exam unless @course_proposal.submit_fields[0].exam_none.nil?
    page.final_exam_rationale_review.should == @course_proposal.submit_fields[0].final_exam_rationale unless @course_proposal.submit_fields[0].exam_standard == :set

    #FIXED OUTCOME
    page.outcome_type_review(1).should == "Fixed" unless @course_proposal.submit_fields[0].outcome_list[3].outcome_type.nil?
    page.outcome_credit_review(1) == "#{@course_proposal.submit_fields[0].outcome_list[3].credit_value}" unless @course_proposal.submit_fields[0].outcome_list[3].credit_value.nil?

    #RANGE OUTCOME
    page.outcome_type_review(2).should == "Multiple" unless @course_proposal.submit_fields[0].outcome_list[1].outcome_type.nil?
    page.outcome_credit_review(2) == "#{@course_proposal.submit_fields[0].outcome_list[1].credit_value}" unless @course_proposal.submit_fields[0].outcome_list[1].credit_value.nil?

    #MULTIPLE OUTCOME
    page.outcome_type_review(3).should == "Range" unless @course_proposal.submit_fields[0].outcome_list[2].outcome_type.nil?
    page.outcome_credit_review(3) == "#{@course_proposal.submit_fields[0].outcome_list[2].credit_value}" unless @course_proposal.submit_fields[0].outcome_list[2].credit_value.nil?


    #ACTIVITY FORMAT
    page.format_level_review(@course_proposal.approve_fields[0].format_list[0].format_level).should == "Format #{@course_proposal.approve_fields[0].format_list[0].format_level}"
    page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].type}".gsub(/\s+/, "") unless @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
    page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "ExperientialLearningOROther" if @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
    page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contacted_hours}"
    page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contact_frequency}"
    page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_type}"
    page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_count}"
    page.activity_class_size_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should == "#{@course_proposal.approve_fields[0].format_list[0].class_size}"


    #ACTIVE DATES SECTION
    page.start_term_review.should == @course_proposal.submit_fields[0].start_term unless @course_proposal.submit_fields[0].start_term.nil?

  end

end


And /^I should see updated data on the Review proposal page for course (.*?)$/ do |proposal_type|
  if proposal_type == "proposal"
    on CmCourseInformation do |page|
      page.review_proposal
      page.loading_wait
    end

    on CmReviewProposal do |page|
      page.growl_text.should == "Document was successfully saved."
      page.proposal_title_review.should == @course_proposal_faculty.proposal_title
      page.course_title_review.should == @course_proposal_faculty.course_title
    end
  else
    on CmCourseInformation do |page|
      page.review_proposal
      page.loading_wait
      page.growl_text.should == "Document was successfully saved."
    end
    on CmReviewProposal do |page|
      page.proposal_title_review.should == @course_proposal_cs.proposal_title
      page.course_title_review.should == @course_proposal_cs.course_title
    end
  end
end

When /^I complete the required fields on the course proposal$/ do
  @course_proposal = create CmCourseProposalObject, :required_fields_only => false,
                                                    :submit_fields => [(make CmSubmitFieldsObject)],
                                                    :approve_fields => [(make CmApproveFieldsObject)]

end

When(/^I create a basic course proposal with alternate identifier details$/) do
  @course_proposal = create CmCourseProposalObject,cross_listed_course_list:    [(make CmCrossListedObject, :auto_lookup => true), (make CmCrossListedObject, :cross_list_course_count => 2)],
                                                   jointly_offered_course_list: [
                                                                                 (make CmJointlyOfferedObject, :search_type => "name"),
                                                                                 (make CmJointlyOfferedObject, :search_type => "course code", :jointly_offered_course_count => 2, :search_by => "Courses Only"),
                                                                                 (make CmJointlyOfferedObject, :search_type => "plain text", :jointly_offered_course_count => 3, :search_by => "Proposals Only"),
                                                                                 (make CmJointlyOfferedObject, :search_type => "blank", :jointly_offered_course_count => 4, :search_by => "Proposals Only"),
                                                                                 (make CmJointlyOfferedObject, :auto_lookup => true, :jointly_offered_course_count =>5)
                                                                                ],
                                                   version_code_list:           [(make CmVersionCodeObject), (make CmVersionCodeObject, :version_code_count => 2) ]


end


Then(/^I should see alternate identifier details on the course proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|

    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    #Cross Listed Courses
    @course_proposal.cross_listed_course_list.each do |cross_list|
      page.cross_listed_courses_review.should include cross_list.cross_list_subject_code
    end

    #Jointly Offered Courses
    @course_proposal.jointly_offered_course_list.each do |jointly_offered|
      page.jointly_offered_courses_review.should include jointly_offered.jointly_offered_course
    end

    #Version Code
    @course_proposal.version_code_list.each do |version|
      page.version_codes_review.should include version.version_code
      page.version_codes_review.should include version.version_course_title
    end

  end

end


And(/^I have a basic course proposal with alternate identifier details$/) do
  @course_proposal = create CmCourseProposalObject,
                            cross_listed_course_list:    [(make CmCrossListedObject, :auto_lookup => true), (make CmCrossListedObject, :cross_list_course_count => 2)],
                            jointly_offered_course_list: [
                                                          (make CmJointlyOfferedObject, :search_type => "name"),
                                                          (make CmJointlyOfferedObject, :search_type => "course code", :jointly_offered_course_count => 2, :search_by => "Courses Only"),
                                                          (make CmJointlyOfferedObject, :search_type => "plain text", :jointly_offered_course_count => 3, :search_by => "Proposals Only"),
                                                          (make CmJointlyOfferedObject, :search_type => "blank", :jointly_offered_course_count => 4, :search_by => "Proposals Only"),
                                                          (make CmJointlyOfferedObject, :auto_lookup => true, :jointly_offered_course_count =>5)
                                                          ],
                            version_code_list:           [(make CmVersionCodeObject), (make CmVersionCodeObject, :version_code_count => 2) ]

end


When(/^I update Alternate Identifier details on the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.edit_proposal_action
  @course_proposal.cross_listed_course_list[0].delete :cross_list_course_count => 1,:defer_save => true
  @course_proposal.cross_listed_course_list[1].edit :auto_lookup => true,
                                                    :cross_list_subject_code => "BSCI",
                                                    :cross_list_course_number => "555",
                                                    :cross_list_course_count => 1,
                                                    :defer_save => true

  @course_proposal.jointly_offered_course_list[0].delete :jointly_offered_course_count => 1, :defer_save => true
  @course_proposal.jointly_offered_course_list[1].delete :jointly_offered_course_count => 1, :defer_save => true
  @course_proposal.jointly_offered_course_list[2].edit :jointly_offered_course_count => 1,
                                                       :jointly_offered_course => "PHYS675",
                                                       :auto_lookup => true,
                                                       :defer_save => true

  @course_proposal.version_code_list[0].delete :version_code_count => 1, :defer_save => true

  @course_proposal.version_code_list[1].edit :version_code => "Z",
                                             :version_course_title => "edited title",
                                             :version_code_count => 1




end

Then(/^I should see updated alternate identifier details on the course proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|

    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    #Cross Listed Courses
    page.cross_listed_courses_review.should_not include @course_proposal.cross_listed_course_list[0].cross_list_subject_code
    page.cross_listed_courses_review.should include "#{@course_proposal.cross_listed_course_list[1].cross_list_course_number}"


    #Jointly Offered Courses
    page.jointly_offered_courses_review.should_not include @course_proposal.jointly_offered_course_list[0].jointly_offered_course
    page.jointly_offered_courses_review.should_not include @course_proposal.jointly_offered_course_list[1].jointly_offered_course
    page.jointly_offered_courses_review.should include @course_proposal.jointly_offered_course_list[2].jointly_offered_course
    page.jointly_offered_courses_review.should include @course_proposal.jointly_offered_course_list[3].jointly_offered_course
    page.jointly_offered_courses_review.should include @course_proposal.jointly_offered_course_list[4].jointly_offered_course


    #Version Code
    page.version_codes_review.should_not include @course_proposal.version_code_list[0].version_code
    page.version_codes_review.should_not include @course_proposal.version_code_list[0].version_course_title

    page.version_codes_review.should include @course_proposal.version_code_list[1].version_code
    page.version_codes_review.should include @course_proposal.version_code_list[1].version_course_title

  end
end


When(/^I delete alternate identifier details to the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.edit_proposal_action

  @course_proposal.cross_listed_course_list[0].delete :cross_list_course_count => 1, :defer_save => true
  @course_proposal.cross_listed_course_list[1].delete :cross_list_course_count => 1, :defer_save => true

  @course_proposal.jointly_offered_course_list[0].delete :jointly_offered_course_count => 1, :defer_save => true
  @course_proposal.jointly_offered_course_list[1].delete :jointly_offered_course_count => 1, :defer_save => true
  @course_proposal.jointly_offered_course_list[2].delete :jointly_offered_course_count => 1, :defer_save => true
  @course_proposal.jointly_offered_course_list[3].delete :jointly_offered_course_count => 1, :defer_save => true
  @course_proposal.jointly_offered_course_list[4].delete :jointly_offered_course_count => 1, :defer_save => true

  @course_proposal.version_code_list[0].delete :version_code_count => 1, :defer_save => true
  @course_proposal.version_code_list[1].delete :version_code_count => 1

end

Then(/^I should no longer see alternate identifier details on the course proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|

    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    #Cross Listed Courses
    @course_proposal.cross_listed_course_list.each do |cross_list|
      page.cross_listed_courses_review.should_not include cross_list.cross_list_subject_code
    end

    #Jointly Offered Courses
    @course_proposal.jointly_offered_course_list.each do |jointly_offered|
      page.jointly_offered_courses_review.should_not include jointly_offered.jointly_offered_course
    end

    #Version Code
    @course_proposal.version_code_list.each do |version|
      page.version_codes_review.should_not include version.version_code
      page.version_codes_review.should_not include version.version_course_title
    end

  end


end
#-----
# S2
#-----



=begin
When /^I complete the required fields on the course proposal$/ do

  # Change to 'I complete the fields required to submit the course proposal'



  #@course_proposal.KradCourseProposalRequired
  #@course_proposal.create_course_proposal_required
  @course_proposal  = create CmCourseProposalObject,
                           #REQUIRED
                           #COURSE INFORMATION
                           #proposal_title: random_alphanums(10,'test proposal title '),
                           #course_title: random_alphanums(10, 'test course title'),
                           subject_code: 'MATH',
                           course_number: rand(100..999).to_s,
                           transcript_course_title:  random_alphanums(5,'test transcript'),

                           joint_offering_adding_method: ['adv_given_name', 'adv_course_code', 'adv_plain_text', 'auto_lookup'].sample,
                           instructor_adding_method:   ['auto_lookup', 'advanced', 'advanced_username', 'advanced_name'].sample,
                           description_rationale: random_alphanums(200),
                           proposal_rationale:    random_alphanums(200),
                           #GOVERNANCE
                           curriculum_oversight:  'CMNS-Mathematics',
                           #COURSE LOGISTICS
                           scheduling_term:      [:term_any, :term_fall, :term_spring, :term_summer],
                           final_exam_status:    [:exam_standard, :exam_alternate, :exam_none],
                           final_exam_rationale: random_alphanums(50),
                           outcome_type:       '::random::', #['Fixed', 'Multiple', 'Range'].sample,
                           outcome_value:      rand(1..3).to_s,
                           credit_value_min:   rand(1..3).to_s,
                           credit_value_max:   rand(4..8).to_s,
                           outcome_multiple:   rand(1..3).to_s,
                           outcome_multiple2:  rand(4..7).to_s,

                           activity_duration_type: '::random::', #['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
                           activity_type: '::random::', #['Directed', 'Discussion', 'Experiential Learning/Other', 'Homework', 'Lab', 'Lecture', 'Tutorial', 'Web Discuss', 'Web Lecture'].sample,
                           activity_frequency: '::random::', #['per day', 'per month', 'per week'].sample,
                           activity_contacted_hours: rand(1..9).to_s,
                           activity_duration_count: rand(1..9).to_s,
                           activity_class_size: rand(1..9).to_s,

                           #ACTIVE DATES
                           start_term: 'Spring 1980',
                           pilot_course: :set,
                           end_term: 'Fall 1980'
end
=end



=begin
Then /^I should see data in required fields for the course proposal$/ do
  on(CmCourseInfo).course_information

  on CmCourseInfo do |page|
    page.subject_code.value.should == @course_proposal.subject_code
    page.course_number.value.should == @course_proposal.course_number

    #BUG KSCM-1240
    #page.version_code_version_code.value.should == @course_proposal.version_code_version_code
    #page.version_code_title.value.should == @course_proposal.version_code_title

    page.description_rationale.value.should == @course_proposal.description_rationale
    page.proposal_rationale.value.should == @course_proposal.proposal_rationale
  end

  on CmGovernance do |page|
    page.governance
    page.curriculum_oversight_when_added(@course_proposal.curriculum_oversight).should be_present
  end

  on CmLogistics do |page|
    page.logistics

    page.exam_standard.should be_checked unless @course_proposal.exam_standard.nil?
    page.exam_alternate.should be_checked  unless @course_proposal.exam_alternate.nil?
    page.exam_none.should be_checked unless @course_proposal.exam_none.nil?

    page.final_exam_rationale.value.should == @course_proposal.final_exam_rationale unless page.exam_standard.set?

    page.credit_value.value.should == @course_proposal.outcome_value if @course_proposal.outcome_type == 'Fixed'

    page.credit_value_multiple('0').value.should == @course_proposal.outcome_multiple if @course_proposal.outcome_type == 'Multiple'
    page.credit_value_multiple('1').value.should == @course_proposal.outcome_multiple2 if @course_proposal.outcome_type == 'Multiple'

    page.credit_value_min.value.should == @course_proposal.credit_value_min if @course_proposal.outcome_type == "Range"
    page.credit_value_max.value.should == @course_proposal.credit_value_max if @course_proposal.outcome_type == "Range"

    page.activity_type.selected?(@course_proposal.activity_type).should == true

    page.assessment_a_f.should be_checked if @course_proposal.assessment_a_f == :set
    page.assessment_notation.should be_checked if @course_proposal.assessment_notation == :set
    page.assessment_letter.should be_checked if @course_proposal.assessment_letter == :set
    page.assessment_pass_fail.should be_checked if @course_proposal.assessment_pass_fail == :set
    page.assessment_percentage.should be_checked if @course_proposal.assessment_percentage== :set
    page.assessment_satisfactory.should be_checked if @course_proposal.assessment_satisfactory == :set
  end

  on CmActiveDates do |page|
    page.active_dates
    page.start_term.selected?(@course_proposal.start_term).should == true unless @course_proposal.start_term.nil?
    page.pilot_course.should be_checked
    page.end_term.selected?(@course_proposal.end_term).should == true unless @course_proposal.end_term.nil?
  end
end
=end

#-----
# S3
#-----
Given /^I complete all the fields on the course proposal$/ do
  #@course_proposal.KradCourseProposalNonrequired
  #@course_proposal.course_proposal_nonrequired
  @course_proposal  = create CmCourseProposalObject,

                             subject_code: 'MATH',
                             course_number: rand(100..999).to_s,
                             transcript_course_title:  random_alphanums(5,'test transcript'),

                             joint_offering_adding_method: ['adv_given_name', 'adv_course_code', 'adv_plain_text', 'auto_lookup'].sample,
                             instructor_adding_method:   ['auto_lookup', 'advanced', 'advanced_username', 'advanced_name'].sample,
                             description_rationale: random_alphanums(200),
                             proposal_rationale:    random_alphanums(200),
                             #GOVERNANCE
                             curriculum_oversight:  'CMNS-Mathematics',
                             #COURSE LOGISTICS
                             scheduling_term:      [:term_any, :term_fall, :term_spring, :term_summer],
                             final_exam_status:    [:exam_standard, :exam_alternate, :exam_none],
                             final_exam_rationale: random_alphanums(50),
                             outcome_type:       '::random::', #['Fixed', 'Multiple', 'Range'].sample,
                             outcome_value:      rand(1..3).to_s,
                             credit_value_min:   rand(1..3).to_s,
                             credit_value_max:   rand(4..8).to_s,
                             outcome_multiple:   rand(1..3).to_s,
                             outcome_multiple2:  rand(4..7).to_s,

                             activity_duration_type: '::random::', #['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
                             activity_type: '::random::', #['Directed', 'Discussion', 'Experiential Learning/Other', 'Homework', 'Lab', 'Lecture', 'Tutorial', 'Web Discuss', 'Web Lecture'].sample,
                             activity_frequency: '::random::', #['per day', 'per month', 'per week'].sample,
                             activity_contacted_hours: rand(1..9).to_s,
                             activity_duration_count: rand(1..9).to_s,
                             activity_class_size: rand(1..9).to_s,

                             #ACTIVE DATES
                             start_term: 'Spring 1980',
                             pilot_course: :set,
                             end_term: 'Fall 1980',

                             #COURSE INFORMATION
                             course_listing_subject: 'FREN',
                             course_listing_number: '888',
                             joint_offering_number: 'HIST201',
                             instructor_display_name: 'SMITH, DAVID (s.davidb)',
                             instructor_first_name: 'DAVID',
                             instructor_last_name: 'SMITH',
                             instructor_username: 's.davidb',

                             instructor_adding_method:   'auto_lookup',#['auto_lookup', 'advanced', adv_username', 'adv_name'].sample,
                             joint_offering_adding_data: ['adv_given_name', 'adv_course_code', 'adv_plain_text', 'auto_lookup'].sample,

                             joint_offering_name:        'Interpreting American History: From 1865 to the Present',
                             joint_offering_description: 'The United States from the end of the Civil War to the present.',
                             joint_offering_course_code: 'HIST201',

                             #GOVERNANCE
                             admin_org_adding_method:    ['advanced', 'auto_lookup'].sample,
                             administering_organization: 'Biological Sciences',
                             campus_location:            [:location_all, :location_extended, :location_north, :location_south],
                             #BUG FOR IDENTIFIER
                             # adv_admin_org_identifier: 'ORGID-BISI',
                             adv_admin_org_name:         'Biological Sciences',
                             adv_admin_org_abbreviation: 'BISI',

                             #COURSE LOGISTICS
                             duration_type: '::random::', #['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
                             duration_count: rand(1..9).to_s,
                             audit: :set, pass_fail_transcript_grade: :set,

                             #COURSE REQUISITES

                             eligibility_add_method: 'text', #['text', 'advanced'].sample,
                             rule_adv_course_title: 'American Jewish Experience', rule_adv_course_code: 'HIST106', rule_adv_course_description_snip: 'History of the Jews in America',
                             rule_course_field: '', rule_credit: rand(1..4),

                             student_eligibility_rule: 'Must have successfully completed <course>',
                             corequisiste_rule: 'Must be concurrently enrolled in <course>',
                             recommended_preparation_rule: 'Must have successfully completed <course>',
                             antirequisite_rule: 'Must not have successfully completed <course>',
                             repeatable_for_credit_rule: 'May be repeated for a maximum of <n> credits',
                             course_that_restricts_credits_rule: 'Must not have successfully completed <course>',

                             student_eligibility_course: 'HIST110',
                             student_eligibility_title: 'The Ancient World',
                             student_eligibility_phrase: 'Interpretation of select literature and art of the ancient Mediterranean world with a view to illuminating the antecedents of modern culture; religion and myth in the ancient near East; Greek philosophical, scientific, and literary invention; and the Roman tradition in politics and administration.',

                             corequisite_add_method: ['text', 'advanced'],
                             corequisite_title: 'Germany in the Nineteenth Century, 1815-1914',
                             corequisite_course: 'HIST440',
                             corequisite_phrase: 'Examines the social, economic, cultural, and political development of the major German states before 1871 and of Germany, excluding Austria, from 1871 to 1914.',

                             recommended_preparation_course: 'CHEM277',
                             recommended_preparation_title: 'Fundamentals of Analytical and Bioanalytical Chemistry Laboratory',
                             recommended_preparation_phrase: 'Quantitative analysis, inorganic analytical chemistry, and an introduction to bio-analytical instrumentation and techniques.',

                             antirequisite_course: 'HIST453',
                             antirequisite_title: 'Diplomatic History of the United States from 1914',
                             antirequisite_phrase: 'American foreign relations in the 20th-century. World War I, the Great Depression, World War II, the Cold War, the Korean War, and Vietnam. A continuation of HIST452.',

                             repeatable_for_credit_credit: rand(1..5).to_s,

                             course_that_restricts_credits_course: 'HIST454',
                             course_that_restricts_credits_title: 'Constitutional History of the United States: From Colonial Origins to 1860',
                             course_that_restricts_credits_phrase: 'The interaction of government, law, and politics in the constitutional system. The nature and purpose of constitutions and constitutionalism; the relationship between the constitution and social forces and influences, the way in which constitutional principles, rules, ideas, and institutions affect events and are in turn affected by events. The origins of American politics and constitutionalism through the constitutional convention of 1787. Major constitutional problems such as the origins of judicial review, democratization of government, slavery in the territories and political system as a whole.',

                             corequisite_add_method: ['text', 'advanced'].sample,
                             recommended_preparation_add_method: ['text', 'advanced'].sample,
                             antirequisite_add_method: ['text', 'advanced'].sample,
                             course_that_restricts_credits_add_method: ['text', 'advanced'].sample,
                             student_eligibility_add_method: ['text', 'advanced'].sample,

  #AUTHORS & COLLABORATORS
                             author_name_method: ['auto_lookup', 'advanced_name', 'advanced_username'].sample,
                             author_name_search: 'User',author_username_search: 'user1', author_display_name: 'One, User (user1)',
                             author_permission: '::random::', #['Edit, Comments, View', 'Comments, View', 'View'].sample,
                             action_request: 'FYI',




                             author_notation: :set



end




Then /^I should see data in all non required fields for the course proposal$/ do
  on CmCourseInformation do |page|
    page.course_information
    page.transcript_course_title.value.should == @course_proposal.transcript_course_title
    #page.subject_code.value.should == @course_proposal.subject_code
    #@course_proposal.verify_text_field(page, 'course_listing_subject', 'course_listing_number', 'joint_offering_number')
    page.expand_course_listing_section unless page.collapse_course_listing_section.visible?
    page.course_listing_subject.value.should == @course_proposal.course_listing_subject
    page.course_listing_number.value.should == @course_proposal.course_listing_number
    page.joint_offering_number.value.should == @course_proposal.joint_offering_number
    page.added_instructor_name.value.should == @course_proposal.instructor_display_name
  end

  on CmGovernance do |page|
    page.governance
    #@course_proposal.verify_text_field(page, 'added_administering_organization' )
    page.added_administering_organization.value.should == @course_proposal.administering_organization unless @course_proposal.administering_organization.nil?
    page.location_north.should be_checked if @course_proposal.location_north == 'set'
    page.location_south.should be_checked if @course_proposal.location_south == 'set'
    page.location_extended.should be_checked if @course_proposal.location_extended == 'set'
    page.location_all.should be_checked if @course_proposal.location_all == 'set'
  end

  on CmCourseLogistics do |page|
    page.course_logistics
    page.term_any.should be_checked if @course_proposal.term_any == 'set'
    page.term_fall.should be_checked if @course_proposal.term_fall == 'set'
    page.term_spring.should be_checked if @course_proposal.term_spring == 'set'
    page.term_summer.should be_checked if @course_proposal.term_summer == 'set'

    page.duration_count.value.should == @course_proposal.duration_count unless @course_proposal.duration_count.nil?
    page.duration_type.selected?(@course_proposal.duration_type).should == true unless @course_proposal.duration_type.nil?

    page.audit.should be_checked
    page.pass_fail_transcript_grade.should be_checked

    #@course_proposal.verify_text_field(page, 'activity_contacted_hours', 'activity_duration_count', 'activity_class_size' )

    page.contacted_hours.value.should == @course_proposal.activity_contacted_hours
    page.frequency.selected?(@course_proposal.activity_frequency).should == true unless @course_proposal.activity_frequency.nil?
    page.duration_count.value.should == @course_proposal.activity_duration_count
    page.duration_type.selected?(@course_proposal.activity_duration_type).should == true unless @course_proposal.activity_duration_type.nil?
    page.class_size.value.should == @course_proposal.activity_class_size


  end
  #on KradLearningObjectives do |page|
  #  page.learning_objectives
  #end

  on CmCourseRequisites do |page|
    page.course_requisites

    page.course_requisite_added_rule(@course_proposal.student_eligibility_rule_with_value).should be_present unless @course_proposal.student_eligibility_rule.nil?
    page.course_requisite_added_rule(@course_proposal.corequisite_rule_with_value).should be_present unless @course_proposal.corequisite_rule.nil?

    #page.course_requisite_added_rule().should be_present unless @course_proposal.student_eligibility_prerequisite_rule.nil?
    #page.corequisite_added_rule.should be_present unless @course_proposal.corequisite_rule.nil?

    page.recommended_preparation_added_rule(@course_proposal.recommended_preparation_rule_with_value).should be_present unless @course_proposal.recommended_preparation_rule.nil?
    page.antirequisite_added_rule(@course_proposal.antirequisite_rule_with_value).should be_present unless @course_proposal.antirequisite_rule.nil?
    page.course_that_restricts_credits_added_rule(@course_proposal.course_that_restricts_credits_rule_with_value).should be_present unless @course_proposal.course_that_restricts_credits_rule.nil?

    page.repeatable_for_credit_added_rule(@course_proposal.repeatable_for_credit_rule_with_value).should be_present unless @course_proposal.repeatable_for_credit_rule.nil?

    #page.course_requisite_added_rule('lets fail here').should be_present

  end

    on CmAuthorsCollaborators do |page|
    page.authors_collaborators
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
  @course_proposal  = create CmCourseProposalObject,

                             subject_code: 'MATH',
                             course_number: rand(100..999).to_s,
                             transcript_course_title:  random_alphanums(5,'test transcript'),

                             joint_offering_adding_method: ['adv_given_name', 'adv_course_code', 'adv_plain_text'].sample,
                             instructor_adding_method:   ['advanced', 'advanced_username', 'advanced_name'].sample,
                             description_rationale: random_alphanums(200),
                             proposal_rationale:    random_alphanums(200),
                             #GOVERNANCE
                             curriculum_oversight:  'CMNS-Mathematics',
                             #COURSE LOGISTICS
                             scheduling_term:      [:term_any, :term_fall, :term_spring, :term_summer],
                             final_exam_status:    [:exam_standard, :exam_alternate, :exam_none],
                             final_exam_rationale: random_alphanums(50),
                             outcome_type:       '::random::', #['Fixed', 'Multiple', 'Range'].sample,
                             outcome_value:      rand(1..3).to_s,
                             credit_value_min:   rand(1..3).to_s,
                             credit_value_max:   rand(4..8).to_s,
                             outcome_multiple:   rand(1..3).to_s,
                             outcome_multiple2:  rand(4..7).to_s,

                             activity_duration_type: '::random::', #['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
                             activity_type: '::random::', #['Directed', 'Discussion', 'Experiential Learning/Other', 'Homework', 'Lab', 'Lecture', 'Tutorial', 'Web Discuss', 'Web Lecture'].sample,
                             activity_frequency: '::random::', #['per day', 'per month', 'per week'].sample,
                             activity_contacted_hours: rand(1..9).to_s,
                             activity_duration_count: rand(1..9).to_s,
                             activity_class_size: rand(1..9).to_s,

                             #ACTIVE DATES
                             start_term: 'Spring 1980',
                             pilot_course: :set,
                             end_term: 'Fall 1980',

                             #COURSE INFORMATION
                             course_listing_subject: 'FREN',
                             course_listing_number: '888',
                             joint_offering_number: 'HIST201',
                             instructor_display_name: 'SMITH, DAVID (s.davidb)',
                             instructor_first_name: 'DAVID',
                             instructor_last_name: 'SMITH',
                             instructor_username: 's.davidb',

                             instructor_adding_method:   ['advanced', 'adv_username', 'adv_name'].sample,
                             joint_offering_adding_data: ['adv_given_name', 'adv_course_code', 'adv_plain_text'].sample,

                             joint_offering_name:        'Interpreting American History: From 1865 to the Present',
                             joint_offering_description: 'The United States from the end of the Civil War to the present.',
                             joint_offering_course_code: 'HIST201',

                             #GOVERNANCE
                             admin_org_adding_method:    'advanced',
                             administering_organization: 'Biological Sciences',
                             campus_location:            [:location_all, :location_extended, :location_north, :location_south],
                             #BUG FOR IDENTIFIER
                             # adv_admin_org_identifier: 'ORGID-BISI',
                             adv_admin_org_name:         'Biological Sciences',
                             adv_admin_org_abbreviation: 'BISI',

                             #COURSE LOGISTICS
                             duration_type: '::random::', #['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
                             duration_count: rand(1..9).to_s,
                             audit: :set, pass_fail_transcript_grade: :set,

                             #COURSE REQUISITES

                             eligibility_add_method: 'text', #['text', 'advanced'].sample,
                             rule_adv_course_title: 'American Jewish Experience', rule_adv_course_code: 'HIST106', rule_adv_course_description_snip: 'History of the Jews in America',
                             rule_course_field: '', rule_credit: rand(1..4),

                             student_eligibility_rule: 'Must have successfully completed <course>',
                             corequisiste_rule: 'Must be concurrently enrolled in <course>',
                             recommended_preparation_rule: 'Must have successfully completed <course>',
                             antirequisite_rule: 'Must not have successfully completed <course>',
                             repeatable_for_credit_rule: 'May be repeated for a maximum of <n> credits',
                             course_that_restricts_credits_rule: 'Must not have successfully completed <course>',

                             student_eligibility_course: 'HIST110',
                             student_eligibility_title: 'The Ancient World',
                             student_eligibility_phrase: 'Interpretation of select literature and art of the ancient Mediterranean world with a view to illuminating the antecedents of modern culture; religion and myth in the ancient near East; Greek philosophical, scientific, and literary invention; and the Roman tradition in politics and administration.',

                             corequisite_add_method: ['text', 'advanced'],
                             corequisite_title: 'Germany in the Nineteenth Century, 1815-1914',
                             corequisite_course: 'HIST440',
                             corequisite_phrase: 'Examines the social, economic, cultural, and political development of the major German states before 1871 and of Germany, excluding Austria, from 1871 to 1914.',

                             recommended_preparation_course: 'CHEM277',
                             recommended_preparation_title: 'Fundamentals of Analytical and Bioanalytical Chemistry Laboratory',
                             recommended_preparation_phrase: 'Quantitative analysis, inorganic analytical chemistry, and an introduction to bio-analytical instrumentation and techniques.',

                             antirequisite_course: 'HIST453',
                             antirequisite_title: 'Diplomatic History of the United States from 1914',
                             antirequisite_phrase: 'American foreign relations in the 20th-century. World War I, the Great Depression, World War II, the Cold War, the Korean War, and Vietnam. A continuation of HIST452.',

                             repeatable_for_credit_credit: rand(1..5).to_s,

                             course_that_restricts_credits_course: 'HIST454',
                             course_that_restricts_credits_title: 'Constitutional History of the United States: From Colonial Origins to 1860',
                             course_that_restricts_credits_phrase: 'The interaction of government, law, and politics in the constitutional system. The nature and purpose of constitutions and constitutionalism; the relationship between the constitution and social forces and influences, the way in which constitutional principles, rules, ideas, and institutions affect events and are in turn affected by events. The origins of American politics and constitutionalism through the constitutional convention of 1787. Major constitutional problems such as the origins of judicial review, democratization of government, slavery in the territories and political system as a whole.',

                             corequisite_add_method: 'advanced',
                             recommended_preparation_add_method: 'advanced',
                             antirequisite_add_method: 'advanced',
                             course_that_restricts_credits_add_method: 'advanced',
                             student_eligibility_add_method: 'advanced',

                             #AUTHORS & COLLABORATORS
                             author_name_method: ['advanced_name', 'advanced_username'].sample,
                             author_name_search: 'User',author_username_search: 'user1', author_display_name: 'One, User (user1)',
                             author_permission: '::random::', #['Edit, Comments, View', 'Comments, View', 'View'].sample,
                             action_request: 'FYI',

                             joint_offering_adding_data: ['adv_given_name', 'adv_course_code', 'adv_plain_text'].sample,
                             instructor_adding_method: ['adv_username', 'adv_name'].sample,
                             admin_org_adding_method: 'advanced',
                             author_name_method: ['advanced_name', 'advanced_username'].sample,



                            author_notation: :set





  #@course_proposal.create_course_proposal_required
  #@course_proposal.course_proposal_nonrequired

end

#create proposal from copy a course as faculty
When(/^I find an approved Course and select copy$/) do
  outcome1 = make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3"
  format11 = (make CmFormatsObject,  :format_level => 1,
                 :activity_level => 1,
                 :type => "Lecture",
                 :contacted_hours => 3,
                 :contact_frequency => "per week",
                 :duration_count => nil,
                 :duration_type => nil,
                 :class_size => 0 )

  format12 = (make CmFormatsObject,  :format_level => 1,
                  :activity_level => 2,
                  :type => "Discussion",
                  :contacted_hours => 3,
                  :contact_frequency => "per week",
                  :duration_count => nil,
                  :duration_type => nil,
                  :class_size => 0 )

  format21 = (make CmFormatsObject,  :format_level => 2,
                  :activity_level => 1,
                  :type => "Lecture",
                  :contacted_hours => 3,
                  :contact_frequency => "per week",
                  :duration_count => nil,
                  :duration_type => nil,
                  :class_size => 0 )

  lo2_cat1 = (make CmLoCategoryObject,:category_name => "Writing - Skill",
                   :category_level => 1,
                   :category_selection => 1,
                   :auto_lookup => true,
                   :defer_save => true)

  lo2_cat2 = (make CmLoCategoryObject,:category_name => "Communication - Skill",
                   :advanced_search => true,
                   :category_selection => 2,
                   :defer_save => true)

  lo2_cat3 = (make CmLoCategoryObject,:category_name => "Scientific reasoning - Skill",
                   :advanced_search => true,
                   :category_selection => 1,
                   :defer_save => true)

  learn_obj2 = (make CmLearningObjectiveObject,
                     :learning_objective_text => "Students will acquire an understanding of the variety of historical human responses to the environment, as well as the roots of contemporary environmental problems and possibilities.",
                     :defer_save => true,
                     :display_level => 1,
                     :category_list => [lo2_cat1, lo2_cat2, lo2_cat3])

  @course = make CmCourseObject, :search_term => "HIST205", :course_code => "HIST205",
                 :subject_code => "HIST", :course_number => "205",
                 :course_title => "Environmental History", :transcript_course_title => "ENVIRONMENTAL HISTORY",
                 :description => "An exploration of the way different societies have used, imagined, and managed nature. Includes examination of questions of land use, pollution, conservation, and the ideology of nature especially, but not exclusively in Europe and North America.",
                 # GOVERNANCE
                 :campus_location => "North",
                 :curriculum_oversight => "ARHU-History",
                 # COURSE LOGISTICS
                 :assessment_scale => "Letter",
                 :audit => "Yes",
                 :pass_fail_transcript_grade => "Yes",
                 :final_exam_status => "Standard Final Exam",
                 :outcome_list => [outcome1],
                 :format_list => [format11, format12, format21],
                 :learning_objective_list => [learn_obj2],
                 # ACTIVE DATES
                 :start_term => "Winter 2010",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"

  @course.view_course

  @course_proposal = create CmCourseProposalObject, :course_to_be_copied => @course,
                            :proposal_title => "copy of #{random_alphanums(10,'course title')}" + @course.course_title,
                            :course_title => "copied " + @course.course_title,
                            :use_view_course => true,
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]
end

Then(/^I should see a course proposal with a modified course title$/) do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action

end

Then(/^I should see all the copied details of the course on the Review Proposal page$/) do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|
    #COURSE PROPOSAL INFO
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    #COPIED COURSE DATA
    page.subject_code_review.should == @course.subject_code
    page.course_number_review.should == @course_proposal.approve_fields[0].course_number

    #GOVERNANCE SECTION
    page.curriculum_oversight_error_state.nil? == false
    page.campus_locations_review.should == @course.campus_location unless @course.campus_location.nil?

    #COURSE LOGISTICS SECTION
    #ASSESSMENT SCALE
  #  page.assessment_scale_review.should == @course.assessment_scale # app is wrong
    page.audit_review.should == @course.audit
    page.pass_fail_transcript_review.should == @course.pass_fail_transcript_grade

    #FINAL EXAM
    page.final_exam_status_review.should == @course.final_exam_status unless @course.final_exam_status.nil?

    #NO OUTCOME
    page.outcome_empty_text.nil? == false

    #ACTIVITY FORMAT
    if (@course.format_list.nil? == false )
      @course.format_list.each do |format|
        page.format_level_review(format.format_level).should == "Format #{format.format_level}"
        page.activity_type_review(format.format_level, format.activity_level).should include "#{format.type}".gsub(/\s+/, "") unless format.type == "Experiential Learning/Other"
        page.activity_type_review(format.format_level, format.activity_level).should include "ExperientialLearningOROther" if format.type == "Experiential Learning/Other"
        page.activity_contact_hours_frequency_review(format.format_level,format.activity_level).should include "#{format.contacted_hours}"
        page.activity_contact_hours_frequency_review(format.format_level,format.activity_level).should include "#{format.contact_frequency}"
        page.activity_duration_type_count_review(format.format_level,format.activity_level).should include "#{format.duration_type}"
        page.activity_duration_type_count_review(format.format_level,format.activity_level).should include "#{format.duration_count}"
        page.activity_class_size_review(format.format_level,format.activity_level).should == "#{format.class_size}"
      end
    end

    #Learning Objectives
    if (@course.learning_objective_list.nil? == false && @course.learning_objective_list.length > 0)
      page.learning_objectives_review(1).should include @course.learning_objective_list[0].learning_objective_text
    end

    #Course Requisites
    if (@course.course_requisite_list.nil? == false && @course.course_requisite_list.length > 0)
      course_requisite = @course.course_requisite_list[0]
      requisite_group = course_requisite.left_group_node

      course_requisite.requisite_type.should == "Student Eligibility & Prerequisite"
      proposal_rules = page.prerequisites_operators_and_rules
      proposal_rules.should include requisite_group.left_rule.complete_rule_text
      proposal_rules.should include requisite_group.right_rule.complete_rule_text
      proposal_rules.should include requisite_group.logic_operator

      proposal_rules.should include course_requisite.right_group_node.complete_rule_text
      proposal_rules.should include course_requisite.logic_operator
    end

    #ACTIVE DATES SECTION
    page.start_term_review.should == ""

  end
end

#create proposal from copy a course as cs
When(/^I create a course proposal from a copy of an approved course$/) do
  generate_course_object_for_copy

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false,
                            :copy_from_course => true, :course_to_be_copied => @course,
                            :proposal_title => "copy of #{random_alphanums(10,'course title')}" + @course.course_title,
                            :course_title => "copy of " + @course.course_title,
                            :curriculum_review_process => "Yes",
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]
end

Then(/^I should see a new course proposal with a modified course title$/) do
  on(CmCourseInformation).course_information

  on CmCourseInformation do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
  end
end

When(/^I create a course admin proposal from a copy of an approved course$/) do
  outcome1 = make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3"
  format = (make CmFormatsObject,  :format_level => 1,
                 :activity_level => 1,
                 :type => "Lecture",
                 :contacted_hours => 3,
                 :contact_frequency => "per week",
                 :duration_count => nil,
                 :duration_type => nil,
                 :class_size => 0 )

  @course = make CmCourseObject, :search_term => "CHEM641", :course_code => "CHEM641",
                 :subject_code => "CHEM", :course_number => "641",
                 :course_title => "Organic Reaction Mechanisms", :transcript_course_title => "ORG REAC MECHANISM",
                 :description => "Development of the tools necessary to use the knowledge of structure an bonding of
                                  molecules and solids in the practice of synthetic inorganic and materials chemistry.
                                  Several bonding models are covered, from the simple valence bond and ligand field models
                                  to a quantitative group theoretical treatment of molecular orbital theory and band structure
                                  descriptions of solids. Concepts of electron counting and oxidation state and ligand characteristics
                                  are revisited in terms of the more sophisticated bonding models. Finally, these models are used to analyze
                                  the reactivity, magnetic and spectroscopic properties of inorganic coordination compounds.
                                  Prior advanced inorganic
                                  and/or advanced quantum chemistry courses are not prerequisites.",
                 # GOVERNANCE
                 :campus_location => "North",
                 :curriculum_oversight => "CMNS-Chemistry & Biochemistry",
                 # COURSE LOGISTICS
                 :assessment_scale => "Letter",
                 :audit => "Yes",
                 :pass_fail_transcript_grade => "No",
                 :final_exam_status => "Standard Final Exam",
                 :outcome_list => [outcome1],
                 :format_list => [format],
                 # ACTIVE DATES
                 :start_term => "Spring 1980",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false,
                            :copy_from_course => true, :course_to_be_copied => @course,
                            :proposal_title => "copy of #{random_alphanums(10,'course title')}" + @course.course_title,
                            :course_title => "copy of " + @course.course_title,
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]
end


Then(/^I should see a new course admin proposal with a modified course title$/) do
  on(CmCourseInformation).course_information

  on CmCourseInformation do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
  end
end

When (/^I create a course proposal from a copy of a proposed course$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  # navigate_rice_to_cm_home
  # @course_proposal.search(@course_proposal.proposal_title)
  # @course_proposal.review_proposal_action
  @orig_course_proposal = @course_proposal
  @course_proposal = create CmCourseProposalObject, :copy_from_proposal => "Yes", :proposal_to_be_copied => @orig_course_proposal,
                                :proposal_title => "copy of #{random_alphanums(10,'proposal title')}" + @course_proposal.course_title,
                                :course_title => "copy of " + @course_proposal.course_title,
                                :curriculum_review_process => "Yes", :create_new_proposal => false
end

Then (/^I should see a new course proposal with modified titles$/) do
  on(CmCourseInformation).course_information

  on CmCourseInformation do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
  end
end

When (/^I create a course admin proposal from a copy of a proposed course$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @orig_course_proposal = @course_proposal
  @course_proposal = create CmCourseProposalObject, :copy_from_proposal => "Yes", :proposal_to_be_copied => @orig_course_proposal,
                            :proposal_title => "copy of #{random_alphanums(10,'admin proposal title')}" + @course_proposal.proposal_title,
                            :course_title => "copy of " + @course_proposal.course_title, :create_new_proposal => false

end

Then (/^I should see a new course admin proposal with modified titles$/) do
  on(CmCourseInformation).course_information

  on CmCourseInformation do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
  end
end

Given (/^I have a course admin proposal created as Alice$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  steps %{When I complete the required fields on the course admin proposal}

end

When (/^I find a proposed course and select copy$/) do
  steps %{Given I am logged in as Faculty}
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action

  @orig_course_proposal = @course_proposal

  @course_proposal = create CmCourseProposalObject,
                            :proposal_title => "copy of #{random_alphanums(10,'proposal title')}" + @course_proposal.course_title,
                            :course_title => "copy of " + @course_proposal.course_title,
                            :use_view_course => true,
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => @orig_course_proposal.approve_fields[0].course_number)]
end

And (/^I should see all the copied details of the proposal on the Review Proposal page$/) do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|
    #COURSE PROPOSAL INFO
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    #COURSE INFORMATION SECTION
    page.subject_code_review.should == "#{@orig_course_proposal.submit_fields[0].subject_code}"
    page.course_number_review.should == "#{@orig_course_proposal.approve_fields[0].course_number}"
    page.description_review.should == "#{@orig_course_proposal.submit_fields[0].description_rationale}"
    page.proposal_rationale_review.should == ""

    #GOVERNANCE SECTION
    page.curriculum_oversight_review.should == ""

    #COURSE LOGISTICS SECTION
    #ASSESSMENT SCALE
    page.assessment_scale_review.should == plus_minus if @orig_course_proposal.submit_fields[0].assessment_a_f == :set
    page.assessment_scale_review.should == completed_notation if @orig_course_proposal.submit_fields[0].assessment_notation == :set
    page.assessment_scale_review.should == letter if @orig_course_proposal.submit_fields[0].assessment_letter == :set
    page.assessment_scale_review.should == pass_fail if @orig_course_proposal.submit_fields[0].assessment_pass_fail == :set
    page.assessment_scale_review.should == percentage if @orig_course_proposal.submit_fields[0].assessment_percentage == :set
    page.assessment_scale_review.should == satisfactory if @orig_course_proposal.submit_fields[0].assessment_satisfactory == :set

    #FINAL EXAM
    page.final_exam_status_review.should == standard_exam unless @orig_course_proposal.submit_fields[0].exam_standard.nil?
    page.final_exam_status_review.should == alternate_exam unless @orig_course_proposal.submit_fields[0].exam_alternate.nil?
    page.final_exam_status_review.should == no_exam unless @orig_course_proposal.submit_fields[0].exam_none.nil?
    page.final_exam_rationale_review.should == @orig_course_proposal.submit_fields[0].final_exam_rationale unless @orig_course_proposal.submit_fields[0].exam_standard == :set

    #NO OUTCOME
    page.outcome_empty_text.nil? == false

    #ACTIVITY FORMAT
    if (@orig_course_proposal.approve_fields[0].format_list.nil? == false)
      @orig_course_proposal.approve_fields[0].format_list.each do |format|
        page.format_level_review(format.format_level).should == "Format #{format.format_level}"
        page.activity_type_review(format.format_level, format.activity_level).should include "#{format.type}".gsub(/\s+/, "") unless format.type == "Experiential Learning/Other"
        page.activity_type_review(format.format_level, format.activity_level).should include "ExperientialLearningOROther" if format.type == "Experiential Learning/Other"
        page.activity_contact_hours_frequency_review(format.format_level, format.activity_level).should include "#{format.contacted_hours}"
        page.activity_contact_hours_frequency_review(format.format_level, format.activity_level).should include "#{format.contact_frequency}"
        page.activity_duration_type_count_review(format.format_level, format.activity_level).should include "#{format.duration_type}"
        page.activity_duration_type_count_review(format.format_level, format.activity_level).should include "#{format.duration_count}"
        page.activity_class_size_review(format.format_level, format.activity_level).should == "#{format.class_size}"
      end
    end

    #Learning Objectives
    if (@orig_course_proposal.learning_objective_list.nil? == false && @orig_course_proposal.learning_objective_list.length > 0)
      page.learning_objectives_review(1).should include @orig_course_proposal.learning_objective_list[0].learning_objective_text
    end

    #Course Requisites
    if (@orig_course_proposal.course_requisite_list.nil? == false && @orig_course_proposal.course_requisite_list.length > 0)
      course_requisite = @orig_course_proposal.course_requisite_list[0]
      requisite_group = course_requisite.left_group_node

      course_requisite.requisite_type.should == "Student Eligibility & Prerequisite"
      proposal_rules = page.prerequisites_operators_and_rules
      proposal_rules.should include requisite_group.left_rule.complete_rule_text
      proposal_rules.should include requisite_group.right_rule.complete_rule_text
      proposal_rules.should include requisite_group.logic_operator

      proposal_rules.should include course_requisite.right_group_node.complete_rule_text
      proposal_rules.should include course_requisite.logic_operator
    end

    #ACTIVE DATES SECTION
    page.start_term_review.should == ""

  end
end

#-----
# S5
#-----
=begin
When /^I complete all fields on the course proposal with auto\-lookup$/ do
  @course_proposal  = create CmCourseProposalObject,
                           subject_code: 'MATH',
                           course_number: rand(100..999).to_s,
                           transcript_course_title:  random_alphanums(5,'test transcript'),

                           joint_offering_adding_method: ['adv_given_name', 'adv_course_code', 'adv_plain_text'].sample,
                           instructor_adding_method:   ['advanced', 'advanced_username', 'advanced_name'].sample,
                           description_rationale: random_alphanums(200),
                           proposal_rationale:    random_alphanums(200),
                           #GOVERNANCE
                           curriculum_oversight:  'CMNS-Mathematics',
                           #COURSE LOGISTICS
                           scheduling_term:      [:term_any, :term_fall, :term_spring, :term_summer],
                           final_exam_status:    [:exam_standard, :exam_alternate, :exam_none],
                           final_exam_rationale: random_alphanums(50),
                           outcome_type:       '::random::', #['Fixed', 'Multiple', 'Range'].sample,
                           outcome_value:      rand(1..3).to_s,
                           credit_value_min:   rand(1..3).to_s,
                           credit_value_max:   rand(4..8).to_s,
                           outcome_multiple:   rand(1..3).to_s,
                           outcome_multiple2:  rand(4..7).to_s,

                           activity_duration_type: '::random::', #['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
                           activity_type: '::random::', #['Directed', 'Discussion', 'Experiential Learning/Other', 'Homework', 'Lab', 'Lecture', 'Tutorial', 'Web Discuss', 'Web Lecture'].sample,
                           activity_frequency: '::random::', #['per day', 'per month', 'per week'].sample,
                           activity_contacted_hours: rand(1..9).to_s,
                           activity_duration_count: rand(1..9).to_s,
                           activity_class_size: rand(1..9).to_s,

                           #ACTIVE DATES
                           start_term: 'Spring 1980',
                           pilot_course: :set,
                           end_term: 'Fall 1980',

                           #COURSE INFORMATION
                           course_listing_subject: 'FREN',
                           course_listing_number: '888',
                           joint_offering_number: 'HIST201',
                           instructor_display_name: 'SMITH, DAVID (s.davidb)',
                           instructor_first_name: 'DAVID',
                           instructor_last_name: 'SMITH',
                           instructor_username: 's.davidb',

                           instructor_adding_method:   'auto_lookup',#['auto_lookup', 'advanced', adv_username', 'adv_name'].sample,
                           joint_offering_adding_data: ['adv_given_name', 'adv_course_code', 'adv_plain_text'].sample,

                           joint_offering_name:        'Interpreting American History: From 1865 to the Present',
                           joint_offering_description: 'The United States from the end of the Civil War to the present.',
                           joint_offering_course_code: 'HIST201',

                           #GOVERNANCE
                           admin_org_adding_method:    'auto_lookup',
                           administering_organization: 'Biological Sciences',
                           campus_location:            [:location_all, :location_extended, :location_north, :location_south],
                           #BUG FOR IDENTIFIER
                           # adv_admin_org_identifier: 'ORGID-BISI',
                           adv_admin_org_name:         'Biological Sciences',
                           adv_admin_org_abbreviation: 'BISI',

                           #COURSE LOGISTICS
                           duration_type: '::random::', #['Day', 'Four Years', 'Half Semester', 'Hours', 'Mini-mester', 'Minutes', 'Month', 'Period', 'Quarter', 'Semester', 'Session', 'TBD', 'Term', 'Two Years', 'Week', 'Year'].sample,
                           duration_count: rand(1..9).to_s,
                           audit: :set, pass_fail_transcript_grade: :set,

                           #COURSE REQUISITES
                           eligibility_add_method: 'text', #['text', 'advanced'].sample,
                           rule_adv_course_title: 'American Jewish Experience', rule_adv_course_code: 'HIST106', rule_adv_course_description_snip: 'History of the Jews in America',
                           rule_course_field: '', rule_credit: rand(1..4),

                           student_eligibility_rule: 'Must have successfully completed <course>',
                           corequisiste_rule: 'Must be concurrently enrolled in <course>',
                           recommended_preparation_rule: 'Must have successfully completed <course>',
                           antirequisite_rule: 'Must not have successfully completed <course>',
                           repeatable_for_credit_rule: 'May be repeated for a maximum of <n> credits',
                           course_that_restricts_credits_rule: 'Must not have successfully completed <course>',

                           student_eligibility_course: 'HIST110',
                           student_eligibility_title: 'The Ancient World',
                           student_eligibility_phrase: 'Interpretation of select literature and art of the ancient Mediterranean world with a view to illuminating the antecedents of modern culture; religion and myth in the ancient near East; Greek philosophical, scientific, and literary invention; and the Roman tradition in politics and administration.',

                           corequisite_add_method: ['text', 'advanced'],
                           corequisite_title: 'Germany in the Nineteenth Century, 1815-1914',
                           corequisite_course: 'HIST440',
                           corequisite_phrase: 'Examines the social, economic, cultural, and political development of the major German states before 1871 and of Germany, excluding Austria, from 1871 to 1914.',

                           recommended_preparation_course: 'CHEM277',
                           recommended_preparation_title: 'Fundamentals of Analytical and Bioanalytical Chemistry Laboratory',
                           recommended_preparation_phrase: 'Quantitative analysis, inorganic analytical chemistry, and an introduction to bio-analytical instrumentation and techniques.',

                           antirequisite_course: 'HIST453',
                           antirequisite_title: 'Diplomatic History of the United States from 1914',
                           antirequisite_phrase: 'American foreign relations in the 20th-century. World War I, the Great Depression, World War II, the Cold War, the Korean War, and Vietnam. A continuation of HIST452.',

                           repeatable_for_credit_credit: rand(1..5).to_s,

                           course_that_restricts_credits_course: 'HIST454',
                           course_that_restricts_credits_title: 'Constitutional History of the United States: From Colonial Origins to 1860',
                           course_that_restricts_credits_phrase: 'The interaction of government, law, and politics in the constitutional system. The nature and purpose of constitutions and constitutionalism; the relationship between the constitution and social forces and influences, the way in which constitutional principles, rules, ideas, and institutions affect events and are in turn affected by events. The origins of American politics and constitutionalism through the constitutional convention of 1787. Major constitutional problems such as the origins of judicial review, democratization of government, slavery in the territories and political system as a whole.',

                           corequisite_add_method: 'text',
                           recommended_preparation_add_method: 'text',
                           antirequisite_add_method: 'text',
                           course_that_restricts_credits_add_method: 'text',
                           student_eligibility_add_method: 'text',

                           #AUTHORS & COLLABORATORS
                           author_name_method: 'auto_lookup',
                           author_name_search: 'User',author_username_search: 'user1', author_display_name: 'One, User (user1)',
                           author_permission: '::random::', #['Edit, Comments, View', 'Comments, View', 'View'].sample,
                           action_request: 'FYI',

                           joint_offering_adding_data: 'auto_lookup',
                           instructor_adding_method: 'auto_lookup',
                           admin_org_adding_method: 'auto_lookup',
                           author_name_method: 'auto_lookup',

                           author_notation: :set,

                           instructor_adding_method: 'auto_lookup',
                           joint_offering_adding_data: 'auto_lookup',
                           admin_org_adding_method: 'auto_lookup',
                           author_name_method: 'auto_lookup'

  #@course_proposal.create_course_proposal_required
  #@course_proposal.course_proposal_nonrequired

end
=end

def generate_course_object_for_copy
  outcome1 = make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3"
  format = (make CmFormatsObject,  :format_level => 1,
                 :activity_level => 1,
                 :type => "Lecture",
                 :contacted_hours => 3,
                 :contact_frequency => "per week",
                 :duration_count => nil,
                 :duration_type => nil,
                 :class_size => 0 )
  rule1 = (make CmRequisiteRuleObject, :rule => "Free Form Text",
                :complete_rule_text => "Must have completed coursework in advanced calculus")
  rule2 = (make CmRequisiteRuleObject, :logic_operator => "AND", :rule => "Must have successfully completed all courses from <courses>",
                :complete_rule_text => "Must have successfully completed all courses from (PHYS410, PHYS411)")
  rule3 = (make CmRequisiteRuleObject, :rule => "Free Form Text",
                :complete_rule_text => "Students who have taken courses with similar or comparable course content may contact the department")

  rule_group = make CmRequisiteRuleGroupObject, :left_rule => rule1, :right_rule => rule2, :logic_operator => "AND"

  requisite_obj = (make CmCourseRequisite, :left_group_node => rule_group, :right_group_node => rule3,
                        :requisite_type => "Student Eligibility & Prerequisite",
                        :logic_operator => "AND", :rule_list => [(rule1), (rule2), (rule3)])

  @course = make CmCourseObject, :search_term => "PHYS604", :course_code => "PHYS604",
                 :subject_code => "PHYS", :course_number => "604",
                 :course_title => "Methods of Mathematical Physics", :transcript_course_title => "METHODS MATH PHYS",
                 :description => "Ordinary and partial differential equations of physics, boundary value problems, Fourier series, Green's functions, complex variables and contour integration.",
                 # GOVERNANCE
                 :campus_location => "North",
                 :curriculum_oversight => "CMNS-Physics",
                 # COURSE LOGISTICS
                 :assessment_scale => "Letter",
                 :audit => "Yes",
                 :pass_fail_transcript_grade => "No",
                 :final_exam_status => "Standard Final Exam",
                 :outcome_list => [outcome1],
                 :format_list => [format],
                 #Course Requisites
                 :course_requisite_list => [requisite_obj],

                 # ACTIVE DATES
                 :start_term => "Spring 1980",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"
end
