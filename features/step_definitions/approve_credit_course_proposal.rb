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

When(/^I am logged in as a (.*?)$/) do |reviewer|
  determine_reviewer(@course_proposal.submit_fields[0].subject_code)
end


And(/^I attempt to approve the course proposal as (.*?)$/) do |reviewer|
  log_in reviewer,reviewer
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)

end

And(/^I attempt to approve or acknowledge the course proposal as (.*?)$/) do
  log_in reviewer,reviewer
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
end


Then(/^I cannot approve or acknowledge the incomplete proposal$/) do
  @course_proposal.review_proposal_action
  #TODO Add validation to check that Approve is disabled.
end


And(/^I approve the course proposal as (.*?)$/) do |reviewer|
  log_in reviewer, reviewer
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  @course_proposal.approve_proposal
end


Then(/^I cannot approve the incomplete proposal$/) do
  @course_proposal.review_proposal_action
    on CmReviewProposal do |proposal|
      proposal.approval_review.exists?.should be_false
    end
end

Given(/^I have a course proposal with approve fields created as (.*?)$/) do |proposal_author|
  log_in proposal_author, proposal_author

  if proposal_author == "fred"

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "CHEM")],
                                                    :approve_fields => [(make CmApproveFieldsObject)]

  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                      :curriculum_review_process => "Yes",
                                                      :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "CHEM")],
                                                      :approve_fields => [(make CmApproveFieldsObject)]
  end

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end



Given(/^I have a partial completed course proposal created as (.*?)$/) do |proposal_author|
  log_in proposal_author,proposal_author

  if proposal_author == "fred"

    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
                              :approve_fields => [(make CmApproveFieldsObject, :transcript_course_title => nil, :course_number => nil)]

  elsif proposal_author == "alice"
    @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                              :curriculum_review_process => "Yes",
                              :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL")],
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

  on(CmCourseInformation).review_proposal
  @course_proposal.approve_proposal

end

And(/^I approve the completed course proposal$/) do

end


Then(/^the course proposal is successfully approved$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  navigate_rice_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.review_proposal_action
  on CmReviewProposal do |review|
    review.proposal_status.should == "Approved"
  end
end

And(/^the new course is Active$/) do
  steps %{Given I am logged in as Faculty}
  @course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                 :course_state => "Active"
  @course.search_for_course
  on CmReviewProposal do |course_review|
    course_review.course_state_review.capitalize.should include @course.course_state
    #COURSE INFORMATION
    course_review.course_title_review.should include @course.course_title
    "#{course_review.subject_code_review}""#{course_review.course_number_review}".should include @course.course_code
    course_review.description_review.should include @course.description
  end
end