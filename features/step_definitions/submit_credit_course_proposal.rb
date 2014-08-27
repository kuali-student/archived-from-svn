When(/^I complete the required for submit fields on the course proposal$/) do
  outcome = (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample)
  submit_fields = (make CmSubmitFieldsObject, :subject_code => "HIST",
                                              :outcome_list => [outcome],
                                              :final_exam_type => [:exam_standard])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [submit_fields]
end

When(/^I complete the required for submit fields on the credit course proposal$/) do
  outcome = (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample)
  submit_fields = (make CmSubmitFieldsObject, :subject_code => "HIST",
                                              :outcome_list => [outcome],
                                              :final_exam_type => [:exam_standard])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :curriculum_review_process => "Yes",
                                                    :submit_fields => [submit_fields]
end

Then(/^I can see updated status of the course proposal$/) do
  @course_proposal.review_proposal_action
  
  on CmReviewProposal do |review|
    review.proposal_status.should include "enroute"
  end

end

When(/^I do not complete all the required for submit fields on the course proposal$/) do
  submit_fields = (make CmSubmitFieldsObject, :curriculum_oversight => nil,
                                              :outcome_list => [],
                                              :final_exam_type => [:exam_standard])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [submit_fields]
end

Then(/^I cannot submit the incomplete course proposal$/) do
  @course_proposal.submit_button_disabled
end


Given(/^I have a partially completed course proposal created as Faculty$/) do
  steps %{Given I am logged in as Faculty}

  submit_fields = (make CmSubmitFieldsObject, :curriculum_oversight => nil,
                        :outcome_list => [],
                        :final_exam_type => [:exam_standard])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [submit_fields]


end

When(/^I enter remaining fields on the partially created course proposal as Curriculum Specialist$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  navigate_rice_to_cm_home
  @course_proposal.search

  @course_proposal.edit :defer_save => true

  @course_proposal.submit_fields[0].edit :curriculum_oversight => '::random::', :defer_save => true

  @course_proposal.submit_fields[0].add_outcome :outcome => (make CmOutcomeObject,
                                                                  :outcome_type => "Fixed",
                                                                  :outcome_level => 0,
                                                                  :credit_value => 4)

end

Then(/^I submit the course proposal$/) do
    @course_proposal.submit_proposal
end

Then(/^I submit the incomplete course proposal$/) do
  @course_proposal.submit_incomplete_proposal
end

Given(/^there is a proposal enroute with a decision$/) do
  steps %{Given I have a course proposal with approve fields submitted by fred}
  steps %{When I approve the course proposal as carl}
  sleep 30 #TODO to avoid workflow exceptions
end

Then(/^I should see the decisions on the course proposal$/) do
  @course_proposal.review_proposal_action
  @course_proposal.load_decisions_action
  on CmDecisions do |page|
    decision_text = page.row_by_index(1)
    contents = decision_text.split(' ',5)
    contents[0].should == "Approved"
    contents[2].should == "carl"
    contents[4].should include "test decision rationale"
  end

end