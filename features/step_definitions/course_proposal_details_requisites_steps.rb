When(/^I create a basic course proposal$/) do
  steps %{Given I am logged in as Faculty}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')


end

When(/^I create a basic course proposal with two basic Eligibility requisites$/) do
  steps %{Given I am logged in as Faculty}

  rule1 = (make CmRequisiteRuleObject, :rule => "Must have successfully completed <course>",
                :complete_rule_text => "Must have successfully completed ENGL201")
  rule2 = (make CmRequisiteRuleObject, :logic_operator => "AND", :complete_rule_text => "Permission of instructor required")
  requisite_obj1 = (make CmCourseRequisite, :left_group_node => rule1, :right_group_node => rule2, :logic_operator => "AND", :rule_list => [(rule1), (rule2)])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title '),
                            :course_requisite_list => [requisite_obj1]
  sleep 1
end

When(/^I create a basic course proposal with Recommended Preparation rule with multiple variables including course set$/) do
  steps %{Given I am logged in as Faculty}

  rule1 = make CmRequisiteRuleObject,
               :type => "Recommended Preparation",
               :rule => "Must successfully complete a minimum of <n> courses from <courses> with a minimum grade of <gradeType> <grade>",
               :add_method => "advanced",
               :search_course_code => "BSCI2",
               :completed_course_number => 3,
               :course_combination_type => "Approved Courses",
               :complete_rule_text => "Must successfully complete a minimum of 3 courses with a minimum grade of A from"


  requisite_obj1 = (make CmCourseRequisite, :left_group_node => rule1, :requisite_type => "Recommended Preparation", :logic_operator => "AND", :rule_list => [(rule1)])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title '),
                            :course_requisite_list => [requisite_obj1]

end

Then(/^I should see the the basic Eligibility requisites on the course proposal$/) do
  @course_proposal.review_proposal_action
  course_requisite_list = @course_proposal.course_requisite_list
  course_requisite_list.each do |requisite|
    on CmReviewProposal do |page|
      requisite_type = requisite.requisite_type
      case requisite_type
        when "Student Eligibility & Prerequisite"
          page.prerequisites_operator_and_rules.should include requisite.left_group_node.complete_rule_text
          page.prerequisites_operator_and_rules.should include requisite.right_group_node.complete_rule_text
          page.prerequisites_operator_and_rules.should include requisite.logic_operator
        else
          raise "No requisite rule section defined!"
      end
    end
  end
end



Then(/^I should see the multiple variable requisite on the course proposal$/) do
  @course_proposal.review_proposal_action
  course_requisite_list = @course_proposal.course_requisite_list
  course_requisite_list.each do |requisite|
    on CmReviewProposal do |page|
      requisite_type = requisite.requisite_type
      case requisite_type
        when "Recommended Preparation"
          saved_rules = page.preparation_operator_and_rules
          saved_rules.should include requisite.left_group_node.complete_rule_text
          saved_rules.should include("BSCI201")
          saved_rules.should include("BSCI202")
          saved_rules.should include("BSCI203")
        else
          raise "No requisite rule section defined!"
      end
    end
  end
end

Given(/^have a basic course proposal with requisite details$/) do
  steps %{When I create a basic course proposal with two basic Eligibility requisites}
end


When(/^I update the requisite details on the course proposal$/) do
  edited_rule1 = (make CmRequisiteRuleObject, :rule => "Must have successfully completed <course>", :course => "ENGL301",
                :complete_rule_text => "Must have successfully completed ENGL301")
  edited_rule_list = [(edited_rule1), (@course_proposal.course_requisite_list[0].right_group_node)]
  @course_proposal.course_requisite_list[0].edit :requisite_type => "Student Eligibility & Prerequisite", :logic_operator => "OR",
                                                 :left_group_node => edited_rule1, :rule_list => edited_rule_list
  @course_proposal.determine_save_action
end

When(/^I delete the requisite details on the course proposal$/) do
  course_requisite_list = @course_proposal.course_requisite_list
  course_requisite_list.each do |requisite|
    @course_proposal.delete_requisite :requisite_type => requisite.requisite_type
  end

  @course_proposal.determine_save_action
end

Then(/^I should see updated requisite details on the course proposal$/) do
  @course_proposal.review_proposal_action
  course_requisite_list = @course_proposal.course_requisite_list
  course_requisite_list.each do |requisite|
    on CmReviewProposal do |page|
      requisite_type = requisite.requisite_type
      case requisite_type
        when "Student Eligibility & Prerequisite"
          page.prerequisites_operator_and_rules.should include requisite.left_group_node.complete_rule_text
          page.prerequisites_operator_and_rules.should include requisite.right_group_node.complete_rule_text
          page.prerequisites_operator_and_rules.should include requisite.logic_operator
        else
          raise "No requisite rule section defined!"
      end
    end
    end
end

Then(/^I should no longer see with requisite details on the course proposal$/) do
  @course_proposal.review_proposal_action
  course_requisite_list = @course_proposal.course_requisite_list
  course_requisite_list.each do |requisite|
    on CmReviewProposal do |page|
      $requisite_type = requisite.requisite_type
      case $requisite_type
        when "Student Eligibility & Prerequisite"
          page.prerequisites_operator_and_rules.should == ""
        when "Corequisite"
          page.corequisite_operator_and_rules.should == ""
        when "Recommended Preparation"
          page.preparation_operator_and_rules.should == ""
        when "Antirequisite"
          page.antirequisite_operator_and_rules.should == ""
        when "Repeatable for Credit"
          page.restrictsCredits_operator_and_rules.should == ""
        when "Course that Restricts Credits"
          page.repeatableForCredit_operator_and_rules.should == ""
        else
          raise "No requisite rule section defined!"
      end
    end
  end
end
