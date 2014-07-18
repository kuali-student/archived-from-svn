When(/^I create a basic course proposal$/) do
  steps %{Given I am logged in as Faculty}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')


end

And(/^I add two basic Eligibility requisites$/) do
  rule1 = make CmRequisiteRuleObject,
               :rule => "Must have successfully completed <course>"

  requisite_obj1 = (make CmCourseRequisite, :left_group_node => rule1, :logic_operator => "AND")

  @course_proposal.course_requisite_list = [requisite_obj1]
  @student_eligibility_rule_list = [requisite_obj1.current_rule[0], requisite_obj1.left_group_node]
  @course_proposal.add_course_requisites :requisite_type => requisite_obj1.requisite_type,
                                         :eligibility_rule_list =>@student_eligibility_rule_list

#  @course_proposal.determine_save_action

end

Then(/^I should see the the basic Eligibility requisites on the course proposal$/) do
  @course_proposal.review_proposal_action
  # add the verification when App is ready
end

And(/^I add a Recommended Preparation rule with multiple variables including course set$/) do
  rule1 = make CmRequisiteRuleObject,
               :type => "Recommended Preparation",
               :rule => "Must successfully complete a minimum of <n> courses from <courses> with a minimum grade of <gradeType> <grade>",
               :add_method => "advanced",
               :search_course_code => "BSCI2",
               :completed_course_number => 3,
               :course_combination_type => "Approved Courses"

  requisite_obj1 = (make CmCourseRequisite, :left_group_node => rule1, :requisite_type => "Recommended Preparation", :logic_operator => "AND")

  @course_proposal.course_requisite_list = [requisite_obj1]
  @student_eligibility_rule_list = [requisite_obj1.left_group_node]
  @course_proposal.add_course_requisites :requisite_type => requisite_obj1.requisite_type,
                                         :eligibility_rule_list =>@student_eligibility_rule_list

  @course_proposal.determine_save_action

end

Then(/^I should see the multiple variable requisite on the course proposal$/) do
  @course_proposal.review_proposal_action
  # add the verification when App is ready
end

Then(/^I should see the multiple variable requisites on the course proposal$/) do
  @course_proposal.review_proposal_action

end

Given(/^have a basic course proposal with requisite details$/) do
  steps %{When I create a basic course proposal}
  steps %{And I add two basic Eligibility requisites}
end


When(/^I update the requisite details on the course proposal$/) do
   @course_proposal.course_requisite_list[0].rule_list[0].edit :requisite_type => "Prerequisite"
end

Then(/^I should see updated requisite details on the course proposal$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I delete the requisite details on the course proposal$/) do
  course_requisite_list = @course_proposal.course_requisite_list
  course_requisite_list.each do |requisite|
    @course_proposal.delete_requisite_rules :requisite_type => requisite.requisite_type
  end

  @course_proposal.determine_save_action
end

Then(/^I should no longer see with requisite details on the course proposal$/) do
  @course_proposal.review_proposal_action

end
