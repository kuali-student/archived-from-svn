When(/^I create a modify course proposal as Faculty$/) do
  steps %{Given I am logged in as Faculty}
  @course = make CmCourseObject, search_term: "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 course_code: "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 course_state: "Active"

  @modify_course_proposal = make CmCourseProposalObject, proposal_title: "Modify " + @course_proposal.course_title,
                                 course_title: @course_proposal.course_title,
                                 subject_code: @course_proposal.subject_code,
                                 approve_fields: @course_proposal.approve_fields,
                                 submit_fields: @course_proposal.submit_fields,
                                 description_rationale: @course_proposal.description_rationale,
                                 proposal_rationale: @course_proposal.proposal_rationale,
                                 outcome_list: @course_proposal.outcome_list,
                                 format_list: @course_proposal.format_list
  @course.view_course
end

Then(/^I can review the modify course proposal details compared to the course$/) do
  on(CmReviewProposalPage).modify_course

  on CmReviewProposalPage do |review|
    review.review_proposal_title_header.should include @course_proposal.course_title

    review.new_proposal_title_review.should == @modify_course_proposal.course_title
    review.new_proposal_rationale_review.should == ""
    review.new_start_term_review.should == ""

    review.start_term_diff_highlighter.should ==  "cm-compare-highlighter"
    review.proposal_title_diff_highlighter.should ==  "cm-compare-highlighter"

   # review.review_proposal_title_header.should_not include "Admin"

  end

end

When(/^I attempt to create another modify course proposal of the course$/) do
  navigate_to_cm_home
  navigate_to_find_course
  on CmFindACoursePage do |search|
    search.course_code.set @course.search_term
    search.find_courses
    search.view_course(@course.search_term)
  end
end

Then(/^I do not have the option to modify the course$/) do
  #no modify button is present
  (on(CmReviewProposalPage).modify_button.exist?).should == false
end

Given(/^there is a modify course proposal created as Faculty$/) do
  steps %{When I create a modify course proposal as Faculty}
  @current_active_course_version_info = Array.new(4)
  @current_active_course_version_info = @course.get_course_version_info version_index: 0
  @course.close_version_history_dialog


  on(CmReviewProposalPage).modify_course
  @modify_course_proposal.edit_course_information
  @modify_course_proposal.edit  proposal_title: @modify_course_proposal.proposal_title
  puts "modify course proposal: #{@modify_course_proposal.proposal_title}"

  on(CmCourseInformationPage).review_proposal
end


Then(/^I cannot yet submit the modify course proposal$/) do
  on CmReviewProposalPage do |review|
    review.submit_button_disabled.exists?.should be_true
  end

end

When(/^I complete the required for submit fields on the modify course proposal$/) do
  @modify_course_proposal.edit_course_information

  @modify_course_proposal.submit_fields[0].edit proposal_rationale: @modify_course_proposal.proposal_title + " Added test rationale.",
                                                final_exam_type: [:exam_standard],
                                                exam_standard: :set,
                                                start_term: 'Spring 2008'
end

Then(/^I can submit the modify course proposal$/) do
  @modify_course_proposal.submit_proposal
end

And(/^I perform a full search for the modify course proposal$/) do
  navigate_to_cm_home
  @modify_course_proposal.search
  @modify_course_proposal.review_proposal_action
end

Then(/^I can see updated status of the modify course proposal$/) do
  on CmReviewProposalPage do |review|
    review.proposal_status.should include "enroute"
  end

end

When(/^I submit a modify course proposal as Faculty$/) do
  steps %{Given there is a modify course proposal created as Faculty}
  steps %{When I complete the required for submit fields on the modify course proposal}
  @modify_course_proposal.submit_proposal
end

And(/^I Blanket Approve the modify course proposal as CS adding an end term for the version to be superseded$/) do
  log_in "alice", "alice"
  @modify_course_proposal.blanket_approve_with_rationale
  on CmReviewProposalPage do |review|
    review.growl_text.should include "Document was successfully approved"
  end
  sleep 30 # to avoid workflow exceptions
end

Then(/^the modify course proposal is successfully approved$/) do
  @new_active_course_version_info = Array.new(4)
  @superseded_course_version_info = Array.new(4)

  navigate_to_functional_home

  @course.view_course
  @new_active_course_version_info = @course.get_course_version_info version_index: 0
  @superseded_course_version_info = @course.get_course_version_info version_index: 1
  @course.close_version_history_dialog

  @new_active_course_version_info[0].should == "2"
  @new_active_course_version_info[1].should == 'Active'
  @new_active_course_version_info[2].should == 'Spring 2008'

  @superseded_course_version_info[0].should == "1"
  @superseded_course_version_info[1].should == 'Superseded'

  @current_active_course_version_info[0].should == "1"
  @current_active_course_version_info[1].should == 'Active'

end

And(/^the Superseded version has a new end term and the new course version is Active$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I modify a course without a draft version$/) do
  @course = make CmCourseObject, :search_term => "BMGT231", :course_code => "BMGT231",
                 :subject_code => "BMGT", :course_number => "231",
                 :course_title => "Statistical Models For Business", :transcript_course_title => "STAT MODELS BUSINESS",
                 :description => "An introductory course in statistical concepts, including probability from a naive set theory approach, random variables and their properties and the probability distributions of selected discrete and continuous random variables. The concepts of sampling and sampling distributions and the application of these concepts to estimation and hypothesis testing are included as are brief surveys of the regression and ANOVA models.",                 # GOVERNANCE
                 :campus_location => "North",
                 :curriculum_oversight => "BMGT-Robert H. Smith School of Business",
                 # COURSE LOGISTICS
                 :assessment_scale => "Letter; Pass/Fail Grading",
                 :audit => "Yes",
                 :pass_fail_transcript_grade => "Yes",
                 :final_exam_status => "Standard Final Exam",
                 :outcome_list => [(make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3")],
                 # ACTIVE DATES
                 :start_term => "Spring 1989",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"

  @course.view_course
  on(CmReviewProposalPage).modify_course
  on CmCreateCourseStartPage do |page|
    page.modify_course_new_version.click
    page.curriculum_review_process.set
    page.continue
  end
end

Then(/^I can review the modify proposal compared to the course$/) do
  sleep 5
end
