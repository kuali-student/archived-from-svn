Given(/^I have a proposal submitted as Faculty$/) do
  steps %{Given I am logged in as Faculty}

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]


  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end

When(/^I Withdraw the Proposal$/) do
  @course_proposal.withdraw_proposal
end

Then(/^can see the proposal has been Withdrawn$/) do
  return_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposal do |proposal|
    proposal.proposal_status.should include "Withdrawn"
  end
end


Given(/^I have a proposal blanket approved by Curriculum Specialist$/) do
  pending # express the regexp above with the code you wish you had
end


Then(/^I cannot cancel the proposal as (.*?)$/) do  |faculty|
  log_in faculty,faculty
  navigate_rice_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposal do |page|
    begin
      page.withdraw_button.exists?.should be_false
    rescue
      # rescue means that the button was not found
    end
  end

end