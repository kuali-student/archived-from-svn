Given(/^I have an active course created for modify$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  outcome1 = make CmOutcomeObject, :outcome_type =>"Fixed", :outcome_level => 0, :credit_value => "3"
  format = (make CmFormatsObject,  :format_level => 1,
                 :activity_level => 1,
                 :type => "Lecture",
                 :contacted_hours => 3,
                 :contact_frequency => "per week",
                 :duration_count => nil,
                 :duration_type => nil,
                 :class_size => 0 )

  @source_course = make CmCourseObject, :search_term => "ENGL212", :course_code => "ENGL212",
                 :subject_code => "ENGL", :course_number => "212",
                 :course_title => "English Literature: 1800 to the Present", :transcript_course_title => "ENGL LIT 1800-PRES",
                 :description => "Surveys the major literary movements of the period, from Romantic to Victorian to Modern.
                                  Such authors as Wordsworth, Keats, Bronte, Tennyson, Browning, Yeats, Joyce, Woolf.",
                 # GOVERNANCE
                 :campus_location => "North",
                 :curriculum_oversight => "ARHU-English",
                 # COURSE LOGISTICS
                 :assessment_scale => "Letter; Pass/Fail Grading",
                 :audit => "Yes",
                 :pass_fail_transcript_grade => "No",
                 :final_exam_status => "Standard Final Exam",
                 :outcome_list => [outcome1],
                 :format_list => [format],
                 # ACTIVE DATES
                 :start_term => "Fall 2007",
                 :pilot_course => "No",
                 :course_state => "ACTIVE"

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false,
                            :copy_from_course => true, :course_to_be_copied => @source_course,
                            :proposal_title => "copy of #{random_alphanums(10,'course title')}" + @source_course.course_title,
                            :course_title => "copy of " + @source_course.course_title,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]

  puts "Proposal Title: #{@course_proposal.proposal_title}"
  puts "course : #{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}"

  # Transcript Course Title
  # Proposal Rationale
  # Curriculum Oversight
  # Outcome
  # Active Dates
  # Term
  # Final Exam Rationale


  @course_proposal.approve_activate_proposal

end

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
  on CmReviewProposalPage do |review|
    review.review_proposal_title_header.should include @course_proposal.course_title

    review.new_proposal_title_review.should == @modify_course_proposal.proposal_title
    review.new_proposal_rationale_review.should == ""
    review.new_start_term_review.should == ""

    review.start_term_diff_highlighter.should ==  "cm-compare-highlighter"
    review.proposal_title_diff_highlighter.should ==  "cm-compare-highlighter"

    review.review_proposal_title_header.should_not include "Admin"

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

Given(/^I submit a modify course proposal as CS by (.*?)$/) do |proposal_author|
  steps %{When I create a modify course proposal as Curriculum Specialist}
  @modify_course_proposal.edit_course_information
  @modify_course_proposal.edit  proposal_title: @modify_course_proposal.proposal_title
  puts "modify course proposal: #{@modify_course_proposal.proposal_title}"

  @modify_course_proposal.submit_fields[0].edit proposal_rationale: @modify_course_proposal.proposal_title + " Added test rationale.",
                                                final_exam_type: [:exam_standard],
                                                exam_standard: :set,
                                                start_term: 'Spring 2008'
  # on CmActiveDatesPage do |page|
  #   #Active Dates
  #   page.active_dates unless page.current_page('Active Dates').exists?
  #   page.start_term.pick! 'Spring 2008'
  #   page.save_progress
  # end
  # on(CmCourseInformationPage).review_proposal

  @modify_course_proposal.submit_proposal

end

And(/^I approve the modify course proposal as (.*?)$/) do |approver|
  sleep 30 # to avoid workflow exceptions
  log_in approver, approver

  @modify_course_proposal.approve_proposal
end


When(/^I modify a course without curriculum review as Curriculum Specialist$/) do
  generate_course_and_course_proposal
  navigate_to_functional_home
  @course.view_course
  on(CmReviewProposalPage).modify_course
  on CmCreateCourseStartPage do |page|
    page.modify_course_new_version.click
    page.continue
  end
end

Then (/^I can not approve and activate the admin modify proposal$/) do
  on CmReviewProposalPage do |review|
    review.review_proposal_title_header.should include 'Modify: ' + @course_proposal.course_title
    review.review_proposal_title_header.should include '(Admin Proposal)'
  end
  @course_proposal.approve_activate_proposal
  on CmCourseInformationPage do |page|
    #page.course_information
    page.page_validation_header.should include "Start Term: For Approval, Start Term is a required field"
  end

end

When (/^I complete the required for approve fields on the modify course proposal$/) do
  @modify_course_proposal.edit  proposal_title: @modify_course_proposal.proposal_title
  puts "modify course proposal: #{@modify_course_proposal.proposal_title}"

  @modify_course_proposal.submit_fields[0].edit proposal_rationale: @modify_course_proposal.proposal_title + " Added test rationale.",
                                                final_exam_type: [:exam_standard],
                                                exam_standard: :set,
                                                start_term: 'Spring 2008'


  @modify_course_proposal.approve_activate_proposal

end

Then (/^I Approve and Activate the modify course admin proposal$/) do
  @modify_course_proposal.approve_activate_proposal
end


def generate_course_and_course_proposal
  @course = make CmCourseObject, search_term: "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 course_code: "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 course_state: "Active"

  @modify_course_proposal = make CmCourseProposalObject, proposal_title: "Modify: " + @course_proposal.course_title,
                                 course_title: @course_proposal.course_title,
                                 subject_code: @course_proposal.subject_code,
                                 approve_fields: @course_proposal.approve_fields,
                                 submit_fields: @course_proposal.submit_fields,
                                 description_rationale: @course_proposal.description_rationale,
                                 proposal_rationale: @course_proposal.proposal_rationale,
                                 outcome_list: @course_proposal.outcome_list,
                                 format_list: @course_proposal.format_list
end

When(/^I modify a course without creating a new version as Curriculum Specialist$/) do
  @course.modify_course_wo_version
end


Then(/^I can edit the course details of the current version$/) do
  # Edit Transcript Course title and Description
  @course_proposal.edit :transcript_course_title => "UPDT #{random_alphanums(10, 'TRNSCRPT')}", :description => "updated #{random_alphanums(10,'description ')}"
end

And(/^the updates will persist to the current course version$/) do
  navigate_to_functional_home
  @course.search_for_course
  on CmFindACoursePage do |page|
    page.results_list_course_code.rows.count == 1
  end
  @course.view_selected_course
  on CmReviewProposalPage do |page|
    page.transcript_course_title.should == @course_proposal.transcript_course_title
    page.description_review.should == @course_proposal.description_review
    page.course_title_review.should include "Modify:"
    page.review_proposal_title_header.should include "(Admin Update)"
  end
end

Given(/^there is a course with a active modify proposal$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I cannot modify the Draft course version as Curriculum Specialist$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I reject the proposal as Department Reviewer$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I cannot modify the Not Approved course version as Curriculum Specialist$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^there is a course with a superseded version$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I only have the option to modify the superseded course without a version$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^there is a course with a retired version$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I modify a retired course without creating a new version as Curriculum Specialist$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I can see but cannot edit the retired details$/) do
  pending # express the regexp above with the code you wish you had
end