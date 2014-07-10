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
  lo1_cat1 = (make CmLoCategoryObject,:category_name => random_alphanums(10, 'lo1_cat1'),
                   :on_the_fly => true,
                   :defer_save => true)
  learn_obj1 = (make CmLearningObjectiveObject, :learning_objective_text => random_alphanums(10, 'learning objective 1 '),
                                                :learning_objective_level => 1,
                                                :advanced_search => false,
                                                :defer_save => true,
                                                :category_list => [lo1_cat1])

  lo2_cat1 = (make CmLoCategoryObject,:category_name => random_alphanums(10, 'lo2_cat1'),
                                                :on_the_fly => true,
                                                :defer_save => true)

  learn_obj2 = (make CmLearningObjectiveObject, :learning_objective_text => random_alphanums(10, 'learning objective 2 '),
                                                :learning_objective_level => 2,
                                                :advanced_search => false,
                                                :defer_save => true,
                                                :category_list => [lo2_cat1] )


  learn_obj3 = (make CmLearningObjectiveObject, :learning_objective_text => random_alphanums(10, 'learning objective 3 '),
                                                :learning_objective_level => 3,
                                                :advanced_search => false,
                                                :defer_save => true,
                                                :category_list => [] )


  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :learning_objective_list => [learn_obj3, learn_obj2, learn_obj1],
                                                    :defer_save => true
  # Indent LO3
  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Indent",
                                                                          :learning_objective_level => 3

end

When(/^I edit the Learning Objectives$/) do
  navigate_to_cm_home
  @course_proposal.search(@course_proposal.proposal_title)
  @course_proposal.edit_proposal_action
  #Edit LO1
  @course_proposal.learning_objective_list[2].edit :learning_objective_text => "updated learning objective 1" ,
                                                   :learning_objective_level => 1,
                                                   :defer_save => true
  #Delete Category on LO1
  @course_proposal.learning_objective_list[2].category_list[0].delete :lo_level => 1,
                                                                      :category_level => 1,
                                                                      :defer_save => true
  #@course_proposal.learning_objective_list[2].category_list[0].


  #add a new category to LO1
  @course_proposal.learning_objective_list[2].add_category :category => (make CmLoCategoryObject,
                                                                                :category_name =>  random_alphanums(10, 'updated category LO1 '),
                                                                                :category_type => '::random::',
                                                                                :category_level => 1,
                                                                                :lo_level => 1,
                                                                                :on_the_fly => true,
                                                                                :defer_save => true)

  #add a new category to LO2
  @course_proposal.learning_objective_list[1].add_category :category => (make CmLoCategoryObject,
                                                                                :category_name =>  random_alphanums(10, 'updated category LO2 '),
                                                                                :category_type => '::random::',
                                                                                :category_level => 2,
                                                                                :lo_level => 2,
                                                                                :on_the_fly => true,
                                                                                :defer_save => true)

  #Outdent LO3
  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Outdent",
                                                                          :learning_objective_level => 3,
                                                                          :defer_save => true

  #Add new on the fly category for LO3
  @course_proposal.learning_objective_list[0].add_category :category => (make CmLoCategoryObject,
                                                                              :category_name =>  random_alphanums(10, 'New category LO3 '),
                                                                              :category_type => '::random::',
                                                                              :category_level => 3,
                                                                              :lo_level => 3,
                                                                              :on_the_fly => true,
                                                                              :defer_save => true)

  #Move LO3 to top
  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Up",
                                                                          :learning_objective_level => 3,
                                                                          :defer_save => true

  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Up",
                                                                          :learning_objective_level => 2,
                                                                          :defer_save => true

  #Move LO1 down
  @course_proposal.learning_objective_list[2].organize_learning_objective :organize_action => "Down",
                                                                          :learning_objective_level => 2,
                                                                          :defer_save => true

  #Indent LO1 under LO2 and Save
  @course_proposal.learning_objective_list[1].organize_learning_objective :organize_action => "Indent",
                                                                          :learning_objective_level => 3



end

Then(/^I should see updated Learning Objective details on the course proposal$/) do
  @course_proposal.review_proposal_action

  lo_list = @course_proposal.learning_objective_list
  on CmReviewProposal do |page|
    lo_index = 0
    cat_index = 0
    lo_list.each do
      page.learning_objectives_review.should include lo_list[lo_index].learning_objective_text
      unless lo_list[lo_index].category_list[cat_index].nil?
        lo_list[lo_index].category_list.each do
          #page.learning_objectives_review.should include lo_list[lo_index].category_list[cat_index].category_name
          puts "LO Index is #{lo_index}"
          puts "Cat Index is #{cat_index}"
          puts lo_list[lo_index].category_list[cat_index].category_name
        cat_index += 1
        end
      end
        lo_index += 1
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