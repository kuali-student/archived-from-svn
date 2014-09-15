When(/^I create a modify course proposal as Faculty$/) do
  steps %{Given I am logged in as Faculty}
  generate_course_and_course_proposal
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

Then(/^I can not create another modify course$/) do
  navigate_to_cm_home
  navigate_to_find_course
  on CmFindACoursePage do |search|
    search.course_code.set @course.search_term
    search.find_courses
    search.view_course(@course.search_term)
  end
  #no modify button is present
  (on(CmReviewProposalPage).modify_button.exist?).should == false
end

Given(/^there is a modify course proposal created as Faculty$/) do
  steps %{When I create a modify course proposal as Faculty}
  @old_active_course_version_info = Array.new(4)
  @old_active_course_version_info = @course.get_course_version_info version_index: 0
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
  navigate_to_cm_home
  @modify_course_proposal.search
  @modify_course_proposal.review_proposal_action

  on CmReviewProposalPage do |review|
    review.proposal_status.should include 'approved'
  end

end

And(/^the Superseded version has a new end term and the new course version is Active$/) do
  navigate_to_functional_home
  @course.view_course
  on(CmReviewProposalPage).lookup_version_history
  on CmCourseVersionHistoryPage do |page|
    page.version_history_version(0).text.should == '2'
    page.version_history_courseStatus(0).text.should == 'Active'
    page.version_history_startTerm(0).text.should == 'Spring 2008'

    page.version_history_version(1).text.should == '1'
    page.version_history_courseStatus(1).text.should == 'Superseded'
    page.version_history_startTerm(1).text.should == @old_active_course_version_info[2]
#    page.version_history_endTerm(1).text.should_not == ''
  end
end

When(/^I create a modify course proposal as Curriculum Specialist$/) do
  generate_course_and_course_proposal
  navigate_to_functional_home
  @course.view_course
  on(CmReviewProposalPage).modify_course
  on CmCreateCourseStartPage do |page|
    page.modify_course_new_version.click
    page.curriculum_review_process.set
    page.continue
  end
end

Then(/^I can review the modify proposal compared to the course$/) do
  on CmReviewProposal do |review|
    review.review_proposal_title_header.should include @course_proposal.course_title

    review.new_proposal_title_review.should == @modify_course_proposal.course_title
    review.new_proposal_rationale_review.should == ""
    review.new_start_term_review.should == ""

    review.start_term_diff_highlighter.should ==  "cm-compare-highlighter"
    review.proposal_title_diff_highlighter.should ==  "cm-compare-highlighter"

    # review.review_proposal_title_header.should_not include "Admin"

  end

end

Then(/^I do not have the option to modify the course with new version$/) do
  navigate_to_cm_home
  navigate_to_find_course
  on CmFindACoursePage do |search|
    search.course_code.set @course.search_term
    search.find_courses
    search.view_course(@course.search_term)
  end
  #no modify_course_new_version button is present
  on(CmReviewProposalPage).modify_course
  (on(CmCreateCourseStartPage).modify_course_new_version.exist?).should == false
end

And(/^the Superseded version has a new end term$/) do
  navigate_to_functional_home
  @course.view_course
  on(CmReviewProposalPage).lookup_version_history
  on CmCourseVersionHistoryPage do |page|
    page.version_history_version(1).text.should == '1'
    page.version_history_courseStatus(1).text.should == 'Superseded'
    page.version_history_startTerm(1).text.should == @superseded_course_version_info[1]
#    page.version_history_endTerm(1).text.should_not == ''
  end

end

And(/^the new course version is Active$/) do
  on CmCourseVersionHistoryPage do |page|
    page.version_history_version(0).text.should == '2'
    page.version_history_courseStatus(0).text.should == 'Active'
    page.version_history_startTerm(0).text.should == 'Spring 2008'
  end
end

When(/^I submit a modify course proposal as CS by (.*?)$/) do |proposal_author|
  log_in proposal_author, proposal_author

  steps %{When I create a modify course proposal as Curriculum Specialist}
  steps %{When I complete the required for submit fields on the modify course proposal}
  @modify_course_proposal.submit_proposal
end

And(/^I approve the modify course proposal as (.*?)$/) do |approver|
  sleep 30 # to avoid workflow exceptions
  log_in approver, approver

  @modify_course_proposal.approve_proposal
end


def generate_course_and_course_proposal
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
end