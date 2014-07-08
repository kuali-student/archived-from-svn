When(/^I create a basic course proposal with Learning Objectives added using advanced search$/) do
 learn_obj1 = make CmLearningObjectiveObject,
             :learning_objective_text => "historical human",
             :advanced_search => true,
             :search_by_all => :set,
             :lo_selection => 1,
             :category_list => nil,
             :defer_save => true
 learn_obj2 = make CmLearningObjectiveObject,
             :learning_objective_text => "Green",
             :advanced_search => true,
             :search_by_course => :set,
             :search_type => "Title",
             :lo_selection => 2,
             :category_list => nil,
             :defer_save => true
 learn_obj3 = make CmLearningObjectiveObject,
             :learning_objective_text => "Certificate",
             :advanced_search => true,
             :search_by_program => :set,
             :search_type => "Category",
             :category_list => nil,
             :lo_selection => 1,
             :defer_save => true
 learn_obj4 = make CmLearningObjectiveObject,
            :learning_objective_text => "BSCI353",
            :advanced_search => true,
            :search_by_all => :set,
            :search_type => "Code",
            :category_list => nil,
            :lo_selection => 1,
            :defer_save => true

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :learning_objective_list => [learn_obj1, learn_obj2, learn_obj3, learn_obj4]
  #@my_lo = @course_proposal.learning_objective_list[0]
  #@my_lo.show_find_lo_lightbox
  #@my_lo.advanced_find

  @course_proposal.determine_save_action

end

Given(/^I have a basic course proposal with Learning Objectives$/) do
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :learning_objective_list => [(make CmLearningObjectiveObject,
                                                               :learning_objective_text => "learning objective text2",
                                                               :advanced_search => false,
                                                               :defer_save => true,
                                                               :category_list => [(make CmLoCategoryObject,:category_name => random_alphanums(10),:on_the_fly => true,:defer_save => true)])]
end

When(/^I edit the Learning Objectives$/) do
  current_lo = @course_proposal.learning_objective_list[0]
  current_lo.edit(:objective_level=>1, :learning_objective_text=>"Edited learning objective text2")
  @course_proposal.determine_save_action
end

Then(/^I should see updated Learning Objective details on the course proposal$/) do
  @course_proposal.review_proposal_action

  my_lo_list = @course_proposal.learning_objective_list
  on CmReviewProposal do |page|
    index = 0
    my_lo_list.each do
      page.learning_objectives_review.should include my_lo_list[index].learning_objective_text
      index +=1
    end
  end
end

When(/^I delete the Learning Objectives$/) do
  @delete_loo_level = 0
  current_lo = @course_proposal.learning_objective_list[0]
  current_lo.delete(:objective_level=> @delete_loo_level)
  @course_proposal.determine_save_action
end

Then(/^I should no longer see Learning Objective details on the course proposal$/) do
  @course_proposal.review_proposal_action

  my_lo_list = @course_proposal.learning_objective_list
  total = my_lo_list.length
  on CmReviewProposal do |page|
    if(total <= 1)
      page.learning_objectives_empty_text.should == ""
    else
      page.learning_objectives_review.should_not include my_lo_list[@delete_loo_level].learning_objective_text
    end
  end
end