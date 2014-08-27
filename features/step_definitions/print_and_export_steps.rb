When(/^I create a basic course proposal as Faculty$/) do
  steps %{Given I am logged in as Faculty}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false, :create_basic_propsal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')
  @course_proposal.create_course_continue
  @course_proposal.create_basic_proposal
end


Then(/^I can print the course proposal$/) do
  on CmCourseInformation do |page|
    page.print_icon.should exist
  end
end

And(/^export the course proposal$/) do
  @course_proposal.export_proposal # make the export popover appear
  on CmCourseInformation do |page|
    # verify that the action links exist.
    page.export_as_pdf_link.should exist
    page.export_as_doc_link.should exist
  end
end

Given(/^I have a course proposal submitted as Faculty$/) do
  steps %{Given I am logged in as Faculty}
  outcome = (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample)
  submit_fields = (make CmSubmitFieldsObject, :subject_code => "CHEM",
                        :outcome_list => [outcome],
                        :final_exam_type => [:exam_standard])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [submit_fields]
  @course_proposal.submit_proposal
end

When(/^I review course proposal as a Reviewer$/) do
  log_in "edna","edna"
  navigate_rice_to_cm_home
  @course_proposal.search

  @course_proposal.review_proposal_action
end

When(/^I view the course details using Find a Course$/) do
  @course = make CmCourseObject, :course_code => "HIST112", :search_term => "HIST112"
  @course.view_course
end

Then(/^I can print the course details$/) do
  on CmReviewProposal do |page|
    page.print_icon.should exist
  end
end

And(/^export the course details$/) do
  @course.export_course #  make the export popover appear
  on CmReviewProposal do |page|
    # verify that the action links in the export popover exist.
    page.export_as_pdf_link.should exist
    page.export_as_doc_link.should exist
  end
end
