Given(/^I have a course proposal with approve fields partially completed created as (.*?)$/) do |proposal_author|
  log_in proposal_author, proposal_author

  if proposal_author == "fred"
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :subject_code => ["ENGL","CHEM"].sample)],
                                                    :approve_fields => [(make CmApproveFieldsObject, :course_number => nil)]
  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                      :curriculum_review_process => "Yes",
                                                      :submit_fields => [(make CmSubmitFieldsObject, :subject_code => ["ENGL","CHEM"].sample)],
                                                      :approve_fields => [(make CmApproveFieldsObject, :course_number => nil)]
  end

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end

When(/^I am logged in as (.*?)$/) do |reviewer|
  determine_reviewer(@course_proposal.submit_fields[0].subject_code)
end


And(/^I attempt to approve the course proposal$/) do
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)

end

And(/^I approve the course proposal$/) do
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  @course_proposal.approve_proposal
end


Then(/^I cannot approve the incomplete proposal$/) do
  @course_proposal.review_proposal_action
  #TODO Add validation to check that Approve is disabled.
end

Given(/^I have a course proposal with approve fields created as (.*?)$/) do |proposal_author|
  log_in proposal_author, proposal_author

  if proposal_author == "fred"

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :subject_code => ["ENGL","CHEM"].sample)],
                                                    :approve_fields => [(make CmApproveFieldsObject)]

  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                      :curriculum_review_process => "Yes",
                                                      :submit_fields => [(make CmSubmitFieldsObject, :subject_code => ["ENGL","CHEM"].sample)],
                                                      :approve_fields => [(make CmApproveFieldsObject)]
  end

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end


Then(/^I can successfully approve the course proposal$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  on CmReviewProposal do |review|
    review.proposal_status.should == "Enroute"
    review.review_approve.exists?.should be_true #need to improve this to validate that is active rather than just visible.
  end
  
end

Given(/^I have a partial completed course proposal created as (.*?)$/) do |proposal_author|
  log_in proposal_author,proposal_author

  if proposal_author == "fred"

    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => ["ENGL","CHEM"].sample)],
                              :approve_fields => [(make CmApproveFieldsObject, :transcript_course_title => nil, :course_number => nil)]

  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :curriculum_review_process => "Yes",
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => ["ENGL","CHEM"].sample)],
                              :approve_fields => [(make CmApproveFieldsObject, :transcript_course_title => nil, :course_number => nil)]
  end

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal

end


And(/^I complete the missing fields on the proposal$/) do
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.edit :defer_save => true

  @course_proposal.approve_fields[0].edit :transcript_course_title => random_alphanums(5,'edited transcript'),
                                          :course_number => "#{(1..999).to_a.sample}",
                                          :defer_save => false
end

And(/^I approve the completed course proposal$/) do
  on(CmCourseInformation).review_proposal
  @course_proposal.approve_proposal
end
