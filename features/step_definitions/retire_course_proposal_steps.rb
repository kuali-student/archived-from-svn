Given(/^I have an active course$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL",
                                                     :final_exam_type => [:exam_alternate, :exam_none])], #excluded Standard Final exam due to a backlog bug
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}" )]

  puts "Proposal Title: #{@course_proposal.proposal_title}"

  @course_proposal.approve_activate_proposal

  
  
end

When(/^I create a proposal to retire the course$/) do
  steps %{Given I am logged in as Faculty}
  course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 :course_state => "Retired"
  
  @retire_proposal = create CmRetireCourseProposal, :course => course,
                                                    :author_list => [(make CmAuthCollaboratorObject)],
                                                    :supporting_doc_list =>  [(make CmSupportingDocsObject)]
  
  pending # express the regexp above with the code you wish you had
  # Click the Retire button
  # Enter all the required fields  => Proposal Title, Rationale for Retirement, End Term, Last Term Offered, Last Course Catalog Publication Year, Other Comments
  # Add author
  # Add collaborator
  # Save
  # Navigate to Review Proposal
  # Submit and verify success message
  
end

And(/^review the proposal to retire the course$/) do
    @retire_proposal.navigate_to_retire_review
end

And(/^I can review the fields on the proposal to retire$/) do
  #TODO add validation steps once review page is accessible KSCM-1817
end



And(/^I should be able to successfully submit the proposal to retire$/) do
  @retire_proposal.submit_retire_proposal
end


And(/^the proposal to retire is approved by (.*?)$/) do |approver|
  log_in "carol", "carol" if approver == "Department Chair"

  @retire_proposal.approve_retire_proposal


end

And(/^the proposal to retire is blanket approved by (.*?)$/) do |approver|
  log_in "alice", "alice" if approver == "Publication Chair"

end

And(/^the course status is retired$/) do
  steps %{Given I am logged in as Faculty}
  @course.view_course
  on CmReviewProposal do |course_review|
    course_review.course_state_review.should include @course.course_state
  end
end


When(/^I create a proposal to retire with missing required for save fields$/) do
  pending # express the regexp above with the code you wish you had
end


Then(/^I should receive an error message about the missing fields$/) do
  pending # express the regexp above with the code you wish you had
end



And(/^I add the missing fields and review the proposal to retire$/) do
pending # express the regexp above with the code you wish you had
end




Then(/^missing for submit fields are highlighted and proposal cannot be submitted$/) do
pending # express the regexp above with the code you wish you had
end




And(/^I add the missing for submit fields and submit$/) do
pending # express the regexp above with the code you wish you had
end


Then(/^the proposal to retire is submitted successfully$/) do
pending # express the regexp above with the code you wish you had
end