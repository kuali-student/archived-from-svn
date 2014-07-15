When(/^I create a basic course proposal with single variable requisites$/) do
  steps %{Given I am logged in as Faculty}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false, :create_basic_propsal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')
  @course_proposal.create_course_continue
  @course_proposal.create_basic_proposal

  rule1 = make CmRequisiteRuleObject,
               :rule => "Must have successfully completed <course>"

  requisite_obj1 = (make CmCourseRequisite)
  requisite_obj1.left_group_node = rule1
  requisite_obj1.logic_operator = "AND"

  @course_proposal.course_requisite_list = [requisite_obj1]
  @student_eligibility_rule_list = [requisite_obj1.current_rule[0], requisite_obj1.left_group_node]
  @course_proposal = @course_proposal.create_proposal_with_requisites :eligibility_rule_list =>@student_eligibility_rule_list

  @course_proposal.determine_save_action

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
