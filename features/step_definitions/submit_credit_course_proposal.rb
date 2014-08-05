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
    review.proposal_status.should include "Enroute"
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

Then(/^the status of course proposal has not changed$/) do
  #@course_proposal.review_proposal_action

  on CmReviewProposal do |review|
    #TODO need to add validation for whats missing
    review.proposal_status.should include "Saved"
    review.review_proposal_error.should include "This proposal is incomplete"
    review.curriculum_oversight_error_state.should be_true
    review.outcome_error_state.should be_true

  end

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
  @course_proposal.search(@course_proposal.proposal_title)

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
  #Create the enroute proposal
  steps %{Given I am logged in as Faculty}
  steps %{When I complete the required for submit fields on the course proposal}
  #Add approve this proposal
  #for testing just add some comments
  @course_proposal.load_comments_action
  @comment_add = create CmCommentsObject
  @comment_add2 = create CmCommentsObject, :commentText => random_alphanums(10,'test proposal comment 2 '), :index => 1

  @comment_add.close_comment_dialog
end

Then(/^I should see the decisions on the course proposal$/) do
  @decision1 = make CmDecisionsObject
  @decision2 = make CmDecisionsObject
  @course_proposal.edit_proposal_action
  @course_proposal.load_decisions_action
  @decision1.show_decision(1)
  @decision2.show_decision(2)
  #need modify this follow verification statements to final approve
  @decision1.Decision.should == "General"
#  @decision1.Date.should == Date.today.to_s
  @decision1.Actor.should == "fred"
#  @decision1.Rationale == "test proposal comment kkkRc24cvy"

end