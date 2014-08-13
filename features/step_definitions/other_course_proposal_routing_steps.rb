Given(/^I have a course proposal with submit and approve fields submitted by (.*?)$/) do |proposal_author|
  log_in proposal_author, proposal_author

  if proposal_author == "fred"

    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "CHEM")],
                              :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]

  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :curriculum_review_process => "Yes",
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "CHEM")],
                              :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}" )]
  end

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal

end

And(/^I return the course proposal to (.*?) as (.*?)$/) do |return_level, reviewer|
  sleep 30 #to avoid workflow exceptions
  log_in reviewer, reviewer
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  @course_proposal.return_proposal(return_level)
end


Then(/^I can resubmit the course proposal as fred$/) do
  on CmReviewProposal do |review|
    review.proposal_status.should include "Enroute"
    review.resubmit_proposal
  end

end