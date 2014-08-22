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
  sleep 30 #TODO find a better way to avoid exceptions
  log_in reviewer, reviewer
  navigate_rice_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  @course_proposal.return_proposal(return_level)
end


Then(/^I can resubmit the course proposal as (.*?)$/) do |author|
  sleep 30 #TODO find a better way to avoid exceptions
  log_in author,author
  navigate_rice_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  @course_proposal.resubmit_proposal
  on CmReviewProposal do |review|
    review.proposal_status.should include "Enroute"
  end

end

When(/^I FYI the course proposal as a (.*?)$/) do |fyi_reviewer|
  log_in fyi_reviewer, fyi_reviewer

  @course_proposal.fyi_navigate_review
end

Then(/^I can FYI the course proposal as a (.*?)$/) do |fyi_reviewer|
  log_in fyi_reviewer, fyi_reviewer
  navigate_rice_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposal do |proposal|
    proposal.fyi_button.exists?.should be_true
  end
  @course_proposal.fyi_review
end

When(/^I find the course proposal as a (.*?)$/) do |fyi_reviewer|
  log_in fyi_reviewer, fyi_reviewer
  navigate_rice_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
end

Then(/^I do not have the option to FYI the proposal$/) do
    on CmReviewProposal do |proposal|
      begin
        proposal.fyi_button.exists?.should be_false
      rescue
        #means that the button was not found
      end
    end
end


Given(/^I have a course proposal Blanket Approved by (.*?)$/) do |blanket_approver|
  @blanket_approver = blanket_approver
  log_in "fred", "fred"

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "CHEM")],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
  sleep 30 #TODO Find a better way to avoid workflow exceptions

  log_in @blanket_approver, @blanket_approver
  @course_proposal.blanket_approve_with_rationale
  sleep 30 #TODO Find a better way to avoid workflow exceptions
end

When(/^I Acknowledge the course proposal as a (.*?)$/) do |division_chair|
  @division_chair = division_chair
  log_in @division_chair, @division_chair
  @course_proposal.acknowledge
end

Then(/^I can see an Acknowledge decision$/) do
  return_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  @course_proposal.load_decisions_action
  on CmDecisions do |page|
    acknowledge_text = page.row_by_index(1)
    acknowledge_content = acknowledge_text.split(' ', 5)
    acknowledge_content[0].should == "Acknowledged"
    acknowledge_content[2].downcase.should == @division_chair
    acknowledge_content[4].should include "test acknowledge rationale"
  end
end

Given(/^I have a course proposal Approved by (.*?)$/) do |department_chair|
  log_in "fred", "fred"
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}")]

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
  sleep 30 #TODO Find a better way to avoid workflow exceptions

  log_in department_chair, department_chair
  @course_proposal.approve_proposal
  sleep 30 #TODO Find a better way to avoid workflow exceptions
end

When(/^I Blanket Approve the proposal as (.*?)$/) do |blanket_approver|
  log_in blanket_approver, blanket_approver
  @course_proposal.blanket_approve_with_rationale
  sleep 30 #TODO Find a better way to avoid workflow exceptions
end



And(/^I Acknowledge the course proposal as senate reviewer$/) do
  pending # express the regexp above with the code you wish you had
end


Then(/^I can see the Acknowledge decisions$/) do
  return_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  @course_proposal.load_decisions_action
  on CmDecisions do |page|
    author_ack_row = page.row_by_index(1)
    author_text = author_ack_row.split(' ', 5)
    author_text[0].should == "Acknowledged"
    author_text[2].downcase.should == "martha"
    author_text[4].should include "test acknowledge rationale"
  end
end

And(/^Acknowledge decision is not displayed for (.*?)$/) do |department_approver|
  log_in department_approver, department_approver
  navigate_rice_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
    on CmReviewProposal do |page|
      begin
        page.acknowledge_button.exists?.should be_false
      rescue
        # rescue means that the button was not found
      end
    end

end



When(/^I reject the course proposal as (.*?)$/) do |college_level_approver|
    log_in college_level_approver, college_level_approver
    @course_proposal.reject_with_rationale
end

Then(/^the course proposal is successfully rejected$/) do
  return_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposal do |proposal|
    proposal.proposal_status.should include "Rejected"
  end
end

Then(/^I do not have the option to Reject the proposal$/) do
   on CmReviewProposal do |page|
    begin
      page.reject_button.exists?.should be_false
    rescue
      # rescue means that the button was not found
    end
  end
end