When(/^I create a basic course proposal with single variable requisites$/) do
  steps %{Given I am logged in as Faculty}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false, :create_basic_propsal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')
  @course_proposal.create_course_continue
  @course_proposal.create_basic_proposal
  requisite_obj1 = (make CmCourseRequisite)
  @course_proposal.course_requisite_list = [requisite_obj1]
  @course_proposal = @course_proposal.create_proposal_with_requisites

end

Then(/^I should see the single variable requisites on the course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I create a basic course proposal with multiple variable requisites$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the multiple variable requisites on the course proposal$/) do
     pending # express the regexp above with the code you wish you had
end

Given(/^have a basic course proposal with requisite details$/) do
  pending # express the regexp above with the code you wish you had
end


When(/^I update the requisite details on the course proposal$/) do
   pending # express the regexp above with the code you wish you had
end

Then(/^I should see updated requisite details on the course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I delete the requisite details on the course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should no longer see with requisite details on the course proposal$/) do
  pending # express the regexp above with the code you wish you had
end
