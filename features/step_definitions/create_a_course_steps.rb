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
  on CmCourseInformationPage do |page|
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
  on CmCurriculumPage do |page|
    page.cmcurriculum_header.exists?.should == true
  end
end


And /^I should see data in the course title on course information$/ do
  on CmCourseInformationPage do |page|
    page.course_information
    page.course_title.value.should == @course_proposal.course_title
  end
end

When /^I complete the required fields for save on the new course proposal$/ do
  @course_proposal = create CmCourseProposalObject
end

When /^I complete the required fields on the course proposal and save$/ do
  @course_proposal = create CmCourseProposalObject, :curriculum_review_process => "Yes",
                                                    :required_fields_only => false,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :outcome_list => [ (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample),
                                                                                                                      (make CmOutcomeObject, :outcome_type => "Multiple",:outcome_level => 1, :credit_value => "#{(1..4).to_a.sample},#{(5..9).to_a.sample}"),
                                                                                                                      (make CmOutcomeObject, :outcome_type => "Range", :outcome_level => 2, :credit_value => "#{(1..4).to_a.sample}-#{(5..9).to_a.sample}")]
                                                                       )],
                                                    :approve_fields => [(make CmApproveFieldsObject, defer_save: 'true')],
                                                    defer_save: 'true'

  determine_save_action
end


When /^I complete the required fields on the course admin proposal$/ do
  @course_proposal = create CmCourseProposalObject, :required_fields_only => false,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :outcome_list => [
                                                        (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample),
                                                        (make CmOutcomeObject, :outcome_type => "Multiple",:outcome_level => 1, :credit_value => "#{(1..4).to_a.sample},#{(5..9).to_a.sample}"),
                                                        (make CmOutcomeObject, :outcome_type => "Range", :outcome_level => 2, :credit_value => "#{(1..4).to_a.sample}-#{(5..9).to_a.sample}")
                                                    ])],
                                                    :approve_fields => [(make CmApproveFieldsObject, defer_save: 'true')],
                                                    defer_save: 'true'

  determine_save_action
end


Then /^I should see data in required fields for the (.*?)$/ do |proposal_type|


  on(CmCourseInformationPage).course_information

  on CmCourseInformationPage do |page|
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

  on CmGovernancePage do |page|
    page.governance
    page.location_north.should be_checked if @course_proposal.approve_fields[0].location_north == :set
    page.location_south.should be_checked if @course_proposal.approve_fields[0].location_south == :set
    page.location_extended.should be_checked if @course_proposal.approve_fields[0].location_extended == :set
    page.location_all.should be_checked if @course_proposal.approve_fields[0].location_all == :set
    page.curriculum_oversight_when_added(@course_proposal.submit_fields[0].curriculum_oversight).should be_present
  end

  on CmCourseLogisticsPage do |page|
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

  on CmActiveDatesPage do |page|

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
 on CmCourseInformationPage do |page|
   #page.course_information
   page.proposal_title_error_state.exists?.should == true
   page.course_title_error_state.exists?.should == true
   page.growl_text.should include "The form contains errors. Please correct these errors and try again."
   page.page_validation_header.should include "This page has 2 errors"
 end
end

Then /^I should see data in required for save fields for the course proposal$/ do
  on CmCourseInformationPage do |page|
    page.course_information
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
    page.growl_text.should == "Document was successfully saved."
  end
end



And /^I should see data in required for save fields on the Review Proposal page$/ do
  on CmCourseInformationPage do |page|
    page.review_proposal
    page.loading_wait

  end
 
  on CmReviewProposalPage do |page|
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

Then /^I edit the course proposal created as Faculty$/ do
  @course_proposal.edit   :proposal_title => "updated #{random_alphanums(10,'test proposal title ')}",
                          :course_title => "updated #{random_alphanums(10, 'test course title ')}"

  @course_proposal.submit_fields[0].edit :subject_code => "ENGL",
                                         :description_rationale => "updated #{random_alphanums(20, 'test description rationale ')}",
                                         :proposal_rationale => "updated #{random_alphanums(20, 'test proposal rationale ')}",
                                         :curriculum_oversight => '::random::',
                                         :assessment_scale => [:assessment_a_f, :assessment_notation, :assessment_letter, :assessment_pass_fail, :assessment_percentage, :assessment_satisfactory],
                                         :final_exam_type => [:exam_standard, :exam_alternate, :exam_none],
                                         :final_exam_rationale => "updated #{random_alphanums(10,'test final exam rationale ')}",
                                         :start_term => '::random::',
                                         :defer_save => true

  @course_proposal.submit_fields[0].outcome_list[0].delete :defer_save => true, :outcome_level => 0
  @course_proposal.submit_fields[0].add_outcome :outcome => (make CmOutcomeObject,
                                                                  :outcome_type => "Fixed",
                                                                  :outcome_level => 0,
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

And /^I edit the basic details of the course proposal$/ do
  @course_proposal.edit   :proposal_title => "updated #{random_alphanums(10,'test proposal title ')}",
                          :course_title => "updated #{random_alphanums(10, 'test course title ')}"
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
  on CmCourseInformationPage do |page|
    page.review_proposal
    page.loading_wait
  end

  on CmReviewProposalPage do |page|
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

And /^I should see the basic details of of the updated data on the Review proposal page$/ do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action

  on CmReviewProposalPage do |page|
    #COURSE INFORMATION SECTION
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title
  end

end

And /^I should see updated data of the Faculty proposal on the Review proposal page$/ do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action

  on CmReviewProposalPage do |page|
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
    page.outcome_type_review(1).should == "Fixed" unless @course_proposal.submit_fields[0].outcome_list[0].outcome_type.nil?
    page.outcome_credit_review(1) == "#{@course_proposal.submit_fields[0].outcome_list[0].credit_value}" unless @course_proposal.submit_fields[0].outcome_list[0].credit_value.nil?

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

And /^I should see updated data on the Review proposal page$/ do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action

  on CmReviewProposalPage do |page|
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
    on CmCourseInformationPage do |page|
      page.review_proposal
      page.loading_wait
    end

    on CmReviewProposalPage do |page|
      page.growl_text.should == "Document was successfully saved."
      page.proposal_title_review.should == @course_proposal_faculty.proposal_title
      page.course_title_review.should == @course_proposal_faculty.course_title
    end
  else
    on CmCourseInformationPage do |page|
      page.review_proposal
      page.loading_wait
      page.growl_text.should == "Document was successfully saved."
    end
    on CmReviewProposalPage do |page|
      page.proposal_title_review.should == @course_proposal_cs.proposal_title
      page.course_title_review.should == @course_proposal_cs.course_title
    end
  end
end

When /^I complete the required fields on the course proposal$/ do
  @course_proposal = create CmCourseProposalObject, :required_fields_only => false,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :outcome_list => [
                                                        (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample),
                                                        (make CmOutcomeObject, :outcome_type => "Multiple",:outcome_level => 1, :credit_value => "#{(1..4).to_a.sample},#{(5..9).to_a.sample}"),
                                                        (make CmOutcomeObject, :outcome_type => "Range", :outcome_level => 2, :credit_value => "#{(1..4).to_a.sample}-#{(5..9).to_a.sample}"),
                                                        ])],
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

  on CmReviewProposalPage do |page|

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
  @course_proposal.search
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

  on CmReviewProposalPage do |page|

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
  @course_proposal.search
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

  on CmReviewProposalPage do |page|

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

#create proposal from copy a course as faculty
When(/^I find an approved Course and select copy$/) do
  subject_code = "HIST"
  course_number = course_number_generator(subject_code)

  outcome1 = make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3"
  format11 = (make CmFormatsObject,  :format_level => 1,
                 :activity_level => 1,
                 :type => "Discussion",
                 :contacted_hours => 3,
                 :contact_frequency => "per week",
                 :duration_count => nil,
                 :duration_type => nil,
                 :class_size => 0 )

  format21 = (make CmFormatsObject,  :format_level => 1,
                  :activity_level => 2,
                  :type => "Lecture",
                  :contacted_hours => 3,
                  :contact_frequency => "per week",
                  :duration_count => nil,
                  :duration_type => nil,
                  :class_size => 0 )

  format22 = (make CmFormatsObject,  :format_level => 2,
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
                 :format_list => [format11, format21, format22],
                 :learning_objective_list => [learn_obj2],
                 # ACTIVE DATES
                 :start_term => "Winter 2010",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"

  @course.view_course

  sleep 10 #TODO to avoid Format Offering sorting issues.

  @course_proposal = create CmCourseProposalObject, :course_to_be_copied => @course,
                            :proposal_title => "copy of #{random_alphanums(10,'course title')}" + @course.course_title,
                            :course_title => "copied " + @course.course_title,
                            :use_view_course => true,
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => course_number)]

  sleep 30 #TODO to avoid Format Offering sorting issues.

end

Then(/^I should see a course proposal with a modified course title$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action

end

Then(/^I should see all the copied details of the course on the Review Proposal page$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action

  on CmReviewProposalPage do |page|
    #COURSE PROPOSAL INFO
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    #COPIED COURSE DATA
    page.subject_code_review.should == @course.subject_code
    page.course_number_review.should == @course_proposal.approve_fields[0].course_number

    #GOVERNANCE SECTION
    (page.curriculum_oversight_error_state.nil? == false).should == true
    page.campus_locations_review.should == @course.campus_location unless @course.campus_location.nil?

    #COURSE LOGISTICS SECTION
    #ASSESSMENT SCALE
  #  page.assessment_scale_review.should == @course.assessment_scale # app is wrong
    page.audit_review.should == @course.audit
    page.pass_fail_transcript_review.should == @course.pass_fail_transcript_grade

    #FINAL EXAM
    page.final_exam_status_review.should == @course.final_exam_status unless @course.final_exam_status.nil?

    #NO OUTCOME
    (page.outcome_empty_text.nil? == false).should == true

    #ACTIVITY FORMAT needs to ignore format and activity orders because we have no control on the order of formats and activities are created.
    if (@course.format_list.nil? == false)
      length = @course.format_list.length
      num_formats = page.activity_format_review_section.text.scan(/Format/).length
      num_activities = page.activity_format_review_section.text.scan(/Activity/).length
      length.should == num_activities

      for format_level in 1..num_formats do
        page.format_level_review(format_level).should == "Format #{format_level}"
        #number of activities for this format
        num = page.activities_in_format_section(format_level).text.scan(/Activity/).length
        for activity_level in 1..num do
          if page.activity_type_review(format_level, activity_level).include? "Lecture"
            format = get_activity_from_format_list @course.format_list, "Lecture"
            page.activity_type_review(format_level, activity_level).should include "#{format.type}".gsub(/\s+/, "")
          elsif page.activity_type_review(format_level, activity_level).include? "Discussion"
            format = get_activity_from_format_list @course.format_list, "Discussion"
            page.activity_type_review(format_level, activity_level).should include "#{format.type}".gsub(/\s+/, "")

          else page.activity_type_review(format_level, activity_level).include? "Experiential Learning/Other"
            format = get_activity_from_format_list @course.format_list, "Experiential Learning/Other"
            page.activity_type_review(format_level, activity_level).should include "ExperientialLearningOROther"
          end
          page.activity_contact_hours_frequency_review(format_level, activity_level).should include "#{format.contacted_hours}"
          page.activity_contact_hours_frequency_review(format_level, activity_level).should include "#{format.contact_frequency}"
          page.activity_duration_type_count_review(format_level, activity_level).should include "#{format.duration_type}"
          page.activity_duration_type_count_review(format_level, activity_level).should include "#{format.duration_count}"
          page.activity_class_size_review(format_level, activity_level).should == "#{format.class_size}"
          activity_level +=1
        end
        format_level +=1
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
  subject_code = "PHYS"
  course_number = course_number_generator(subject_code)

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false,
                            :copy_from_course => true, :course_to_be_copied => @course,
                            :proposal_title => "copy of #{random_alphanums(10,'course title')}" + @course.course_title,
                            :course_title => "copy of " + @course.course_title,
                            :curriculum_review_process => "Yes",
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => course_number)]
end

Then(/^I should see a new course proposal with a modified course title$/) do
  on(CmCourseInformationPage).course_information

  on CmCourseInformationPage do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
  end
end

When(/^I create a course admin proposal from a copy of an approved course$/) do
  subject_code = "CHEM"
  course_number = course_number_generator(subject_code)

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
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => course_number)]
end


Then(/^I should see a new course admin proposal with a modified course title$/) do
  on(CmCourseInformationPage).course_information

  on CmCourseInformationPage do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
  end
end

When (/^I create a course proposal from a copy of a proposed course$/) do
  sleep 30 #TODO workaround to avoid delay exceptions
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
  on(CmCourseInformationPage).course_information

  on CmCourseInformationPage do |page|
    page.proposal_title.value.should == @course_proposal.proposal_title
    page.course_title.value.should == @course_proposal.course_title
  end
end

When (/^I create a course admin proposal from a copy of a proposed course$/) do
  sleep 30 #TODO workaround to avoid delay exceptions
  steps %{Given I am logged in as Curriculum Specialist}
  @orig_course_proposal = @course_proposal
  @course_proposal = create CmCourseProposalObject, :copy_from_proposal => "Yes", :proposal_to_be_copied => @orig_course_proposal,
                            :proposal_title => "copy of #{random_alphanums(10,'admin proposal title')}" + @course_proposal.proposal_title,
                            :course_title => "copy of " + @course_proposal.course_title, :create_new_proposal => false

end

Then (/^I should see a new course admin proposal with modified titles$/) do
  on(CmCourseInformationPage).course_information

  on CmCourseInformationPage do |page|
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
  @course_proposal.search
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
  @course_proposal.search
  @course_proposal.review_proposal_action

  on CmReviewProposalPage do |page|
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
    (page.outcome_empty_text.nil? == false).should == true

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

  requisite_obj = (make CmCourseRequisiteObject, :left_group_node => rule_group, :right_group_node => rule3,
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

def get_activity_from_format_list (format_list, activity_type)
  format_list.each do |format|
    if format.type == activity_type
      return format
    end
  end
end

When(/^I complete all fields on the create course admin proposal$/) do

  rule1 = (make CmRequisiteRuleObject,:rule => "Must have successfully completed <course>")
  requisite_obj1 = (make CmCourseRequisiteObject,:rule_list => [(rule1)], :defer_save => true )

  @course_proposal = create CmCourseProposalObject, :submit_fields => [(make CmSubmitFieldsObject)],
                            :approve_fields => [(make CmApproveFieldsObject, :defer_save => true)],
                            :cross_listed_course_list =>    [(make CmCrossListedObject, :defer_save => true)],
                            :jointly_offered_course_list => [(make CmJointlyOfferedObject, :defer_save => true)],
                            :version_code_list => [(make CmVersionCodeObject, :defer_save => true)],
                            :learning_objective_list => [(make CmLearningObjectiveObject, :defer_save => true)],
                            :course_requisite_list => [requisite_obj1],
                            :author_list => [(make CmAuthCollaboratorObject, :defer_save => true)],
                            :supporting_doc_list => [(make CmSupportingDocsObject)],
                            :optional_fields => [(make CmOptionalFieldsObject ,:instructor_list => [(make CmInstructorObject, :instructor_name => "TYSON",:defer_set => true)],:admin_org_list => [(make CmAdminOrgObject)],:defer_save => true)]
end


And /^I perform a full search for the create course admin proposal$/ do
  navigate_to_cm_home
  @course_proposal.search
end

Then(/^I can review all details on the create course admin proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposalPage do |page|

      page.proposal_title_review.should == @course_proposal.proposal_title
      page.course_title_review.should == @course_proposal.course_title
      page.transcript_course_title.should == @course_proposal.approve_fields[0].transcript_course_title
      page.subject_code_review.should == "MATH"
      page.course_number_review.should == @course_proposal.approve_fields[0].course_number
      page.cross_listed_courses_review.should include @course_proposal.cross_listed_course_list[0].cross_list_subject_code+@course_proposal.cross_listed_course_list[0].cross_list_course_number.to_s
      page.cross_listed_courses_review.should include @course_proposal.cross_listed_course_list[0].cross_list_course_number.to_s
      page.jointly_offered_courses_review.should == @course_proposal.jointly_offered_course_list[0].jointly_offered_course
      page.version_codes_review.should == @course_proposal.version_code_list[0].version_code+": "+@course_proposal.version_code_list[0].version_course_title
      page.instructors_review.should include @course_proposal.optional_fields[0].instructor_list[0].instructor_name
      page.description_review.should == @course_proposal.submit_fields[0].description_rationale
      page.proposal_rationale_review.should == @course_proposal.submit_fields[0].proposal_rationale
      page.campus_locations_review.should == "North" if @course_proposal.approve_fields[0].location_north == :set
      page.campus_locations_review.should == "South" if @course_proposal.approve_fields[0].location_south == :set
      page.campus_locations_review.should == "Extended" if @course_proposal.approve_fields[0].location_extended == :set
      page.campus_locations_review.should == "All" if @course_proposal.approve_fields[0].location_all == :set
      page.curriculum_oversight_review.should == @course_proposal.submit_fields[0].curriculum_oversight
      page.administering_org_review.should include @course_proposal.optional_fields[0].admin_org_list[0].admin_org_name
      page.terms_review.should include "Any" if @course_proposal.optional_fields[0].term_any == :set
      page.terms_review.should include "Fall" if @course_proposal.optional_fields[0].term_fall == :set
      page.terms_review.should include "Spring" if @course_proposal.optional_fields[0].term_spring == :set
      page.terms_review.should include "Summer" if @course_proposal.optional_fields[0].term_summer == :set
      page.duration_review.should include @course_proposal.optional_fields[0].duration_count.to_s
      page.duration_review.should include @course_proposal.optional_fields[0].duration_type
      page.assessment_scale_review.should include plus_minus if @course_proposal.submit_fields[0].assessment_a_f == :set
      page.assessment_scale_review.should include completed_notation if @course_proposal.submit_fields[0].assessment_notation == :set
      page.assessment_scale_review.should include letter if @course_proposal.submit_fields[0].assessment_letter == :set
      page.assessment_scale_review.should include pass_fail if @course_proposal.submit_fields[0].assessment_pass_fail == :set
      page.assessment_scale_review.should include percentage if @course_proposal.submit_fields[0].assessment_percentage == :set
      page.assessment_scale_review.should include satisfactory if @course_proposal.submit_fields[0].assessment_satisfactory == :set
      page.audit_review.should == "Yes"  if @course_proposal.optional_fields[0].audit == :set
      page.pass_fail_transcript_review.should == "Yes" if @course_proposal.optional_fields[0].pass_fail_transcript_grade == :set
      page.final_exam_status_review.should == standard_exam unless @course_proposal.submit_fields[0].exam_standard.nil?
      page.final_exam_status_review.should == alternate_exam unless @course_proposal.submit_fields[0].exam_alternate.nil?
      page.final_exam_status_review.should == no_exam unless @course_proposal.submit_fields[0].exam_none.nil?
      page.final_exam_rationale_review.should == @course_proposal.submit_fields[0].final_exam_rationale unless @course_proposal.submit_fields[0].exam_standard == :set
      page.format_level_review(@course_proposal.approve_fields[0].format_list[0].format_level).should == "Format #{@course_proposal.approve_fields[0].format_list[0].format_level}"
      page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].type}".gsub(/\s+/, "") unless @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
      page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "ExperientialLearningOROther" if @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
      page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contacted_hours}"
      page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contact_frequency}"
      page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_type}"
      page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_count}"
      page.activity_class_size_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should == "#{@course_proposal.approve_fields[0].format_list[0].class_size}"
      page.learning_objectives_review(1).should include @course_proposal.learning_objective_list[0].learning_objective_text
      page.start_term_review.should == @course_proposal.submit_fields[0].start_term
      page.end_term_review.should == @course_proposal.optional_fields[0].end_term
      page.pilot_course_review.should == "Yes" if @course_proposal.optional_fields[0].pilot_course == :set
      page.fee_justification_review.should == @course_proposal.optional_fields[0].justification_of_fees
      page.author_name_review(1).should include @course_proposal.author_list[0].name
      page.author_permission_review(1).should include "View"
      page.action_request_review(1).should == "FYI"
      page.prerequisites_operators_and_rules.should include @course_proposal.course_requisite_list[0].rule_list[0].rule[0,32]+" ENGL201"
      page.supporting_docs_review.should include "test_file"
      page.supporting_docs_review.should include @course_proposal.supporting_doc_list[0].type
      page.supporting_docs_review.should include @course_proposal.supporting_doc_list[0].description unless @course_proposal.supporting_doc_list[0].description == " "

  end
end


When(/^I complete all fields on the course proposal$/) do

  rule1 = (make CmRequisiteRuleObject,:rule => "Must have successfully completed <course>")
  requisite_obj1 = (make CmCourseRequisiteObject,:rule_list => [(rule1)], :defer_save => true )

  @course_proposal = create CmCourseProposalObject, :submit_fields => [(make CmSubmitFieldsObject)],
                            :approve_fields => [(make CmApproveFieldsObject, :defer_save => true)],
                            :cross_listed_course_list =>    [(make CmCrossListedObject, :defer_save => true)],
                            :jointly_offered_course_list => [(make CmJointlyOfferedObject, :defer_save => true)],
                            :version_code_list => [(make CmVersionCodeObject, :defer_save => true)],
                            :learning_objective_list => [(make CmLearningObjectiveObject, :defer_save => true)],
                            :course_requisite_list =>  [requisite_obj1],
                            :author_list => [(make CmAuthCollaboratorObject, :defer_save => true)],
                            :supporting_doc_list => [(make CmSupportingDocsObject)],
                            :optional_fields => [(make CmOptionalFieldsObject ,:instructor_list => [(make CmInstructorObject, :instructor_name => "TYSON",:defer_set => true)],:admin_org_list => [(make CmAdminOrgObject)],:defer_save => true)]

end


Then(/^I can review all fields on the course proposal$/) do
  @course_proposal.review_proposal_action

      on CmReviewProposalPage do |page|

      page.proposal_title_review.should == @course_proposal.proposal_title
      page.course_title_review.should == @course_proposal.course_title
      page.transcript_course_title.should == @course_proposal.approve_fields[0].transcript_course_title
      page.subject_code_review.should == "MATH"
      page.course_number_review.should == @course_proposal.approve_fields[0].course_number
      page.cross_listed_courses_review.should include @course_proposal.cross_listed_course_list[0].cross_list_subject_code+@course_proposal.cross_listed_course_list[0].cross_list_course_number.to_s
      page.cross_listed_courses_review.should include @course_proposal.cross_listed_course_list[0].cross_list_course_number.to_s
      page.jointly_offered_courses_review.should == @course_proposal.jointly_offered_course_list[0].jointly_offered_course
      page.version_codes_review.should == @course_proposal.version_code_list[0].version_code+": "+@course_proposal.version_code_list[0].version_course_title
      page.instructors_review.should include @course_proposal.optional_fields[0].instructor_list[0].instructor_name
      page.description_review.should == @course_proposal.submit_fields[0].description_rationale
      page.proposal_rationale_review.should == @course_proposal.submit_fields[0].proposal_rationale
      page.campus_locations_review.should == "North" if @course_proposal.approve_fields[0].location_north == :set
      page.campus_locations_review.should == "South" if @course_proposal.approve_fields[0].location_south == :set
      page.campus_locations_review.should == "Extended" if @course_proposal.approve_fields[0].location_extended == :set
      page.campus_locations_review.should == "All" if @course_proposal.approve_fields[0].location_all == :set
      page.curriculum_oversight_review.should == @course_proposal.submit_fields[0].curriculum_oversight
      page.administering_org_review.should include @course_proposal.optional_fields[0].admin_org_list[0].admin_org_name
      page.terms_review.should include "Any" if @course_proposal.optional_fields[0].term_any == :set
      page.terms_review.should include "Fall" if @course_proposal.optional_fields[0].term_fall == :set
      page.terms_review.should include "Spring" if @course_proposal.optional_fields[0].term_spring == :set
      page.terms_review.should include "Summer" if @course_proposal.optional_fields[0].term_summer == :set
      page.duration_review.should include @course_proposal.optional_fields[0].duration_count.to_s
      page.duration_review.should include @course_proposal.optional_fields[0].duration_type
      page.assessment_scale_review.should include plus_minus if @course_proposal.submit_fields[0].assessment_a_f == :set
      page.assessment_scale_review.should include completed_notation if @course_proposal.submit_fields[0].assessment_notation == :set
      page.assessment_scale_review.should include letter if @course_proposal.submit_fields[0].assessment_letter == :set
      page.assessment_scale_review.should include pass_fail if @course_proposal.submit_fields[0].assessment_pass_fail == :set
      page.assessment_scale_review.should include percentage if @course_proposal.submit_fields[0].assessment_percentage == :set
      page.assessment_scale_review.should include satisfactory if @course_proposal.submit_fields[0].assessment_satisfactory == :set
      page.audit_review.should == "Yes"  if @course_proposal.optional_fields[0].audit == :set
      page.pass_fail_transcript_review.should == "Yes" if @course_proposal.optional_fields[0].pass_fail_transcript_grade == :set
      page.final_exam_status_review.should == standard_exam unless @course_proposal.submit_fields[0].exam_standard.nil?
      page.final_exam_status_review.should == alternate_exam unless @course_proposal.submit_fields[0].exam_alternate.nil?
      page.final_exam_status_review.should == no_exam unless @course_proposal.submit_fields[0].exam_none.nil?
      page.final_exam_rationale_review.should == @course_proposal.submit_fields[0].final_exam_rationale unless @course_proposal.submit_fields[0].exam_standard == :set
      page.format_level_review(@course_proposal.approve_fields[0].format_list[0].format_level).should == "Format #{@course_proposal.approve_fields[0].format_list[0].format_level}"
      page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].type}".gsub(/\s+/, "") unless @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
      page.activity_type_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "ExperientialLearningOROther" if @course_proposal.approve_fields[0].format_list[0].type == "Experiential Learning/Other"
      page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contacted_hours}"
      page.activity_contact_hours_frequency_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].contact_frequency}"
      page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_type}"
      page.activity_duration_type_count_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should include "#{@course_proposal.approve_fields[0].format_list[0].duration_count}"
      page.activity_class_size_review(@course_proposal.approve_fields[0].format_list[0].format_level, @course_proposal.approve_fields[0].format_list[0].activity_level).should == "#{@course_proposal.approve_fields[0].format_list[0].class_size}"
      page.learning_objectives_review(1).should include @course_proposal.learning_objective_list[0].learning_objective_text
      page.start_term_review.should == @course_proposal.submit_fields[0].start_term
      page.end_term_review.should == @course_proposal.optional_fields[0].end_term
      page.pilot_course_review.should == "Yes" if @course_proposal.optional_fields[0].pilot_course == :set
      page.fee_justification_review.should == @course_proposal.optional_fields[0].justification_of_fees
      page.author_name_review(1).should include @course_proposal.author_list[0].name
      page.author_permission_review(1).should include "View"
      page.action_request_review(1).should == "FYI"
      page.prerequisites_operators_and_rules.should include @course_proposal.course_requisite_list[0].rule_list[0].rule[0,32]+" ENGL201"
      page.supporting_docs_review.should include "test_file"
      page.supporting_docs_review.should include @course_proposal.supporting_doc_list[0].type
      page.supporting_docs_review.should include @course_proposal.supporting_doc_list[0].description unless @course_proposal.supporting_doc_list[0].description == " "

    end
end