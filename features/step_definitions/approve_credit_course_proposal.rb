Given(/^I have a course proposal with approve fields partially completed created as Faculty$/) do
  steps %{Given I am logged in as Faculty}

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                             :proposal_title => random_alphanums(10,'approve and submit test data'),
                             :submit_fields => [(make CmSubmitFieldsObject, :subject_code => ["ENGL","CHEM"].sample)],
                             :approve_fields => [(make CmApproveFieldsObject, :course_number => nil)]

  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end

When(/^I am logged in as Reviewer$/) do
  determine_reviewer(@course_proposal.submit_fields[0].subject_code)
end


And(/^I attempt to approve the course proposal$/) do

end


Then(/^I cannot approve the incomplete proposal$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I have a course proposal with approve fields created as Faculty$/) do
   pending # express the regexp above with the code you wish you had
end


Then(/^I can successfully approve the course proposal\.$/) do
 pending # express the regexp above with the code you wish you had
end


And(/^I complete the missing fields on the proposal$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I can successfully approve the course proposal$/) do
   pending # express the regexp above with the code you wish you had
end