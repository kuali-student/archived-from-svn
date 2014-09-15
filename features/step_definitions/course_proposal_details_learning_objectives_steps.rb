When(/^I create a basic course proposal with Learning Objectives added using advanced search$/) do
 learn_obj1 = make CmLearningObjectiveObject,
             :learning_objective_text => "historical human",
             :advanced_search => true,
             :search_by_all => :set,
             :lo_selection => 1,
             :category_list => nil,
             :display_level => 5,
             :defer_save => true
 learn_obj2 = make CmLearningObjectiveObject,
             :learning_objective_text => "Green",
             :advanced_search => true,
             :search_by_course => :set,
             :search_type => "Title",
             :lo_selection => 2,
             :category_list => nil,
             :display_level => 3,
             :defer_save => true
 learn_obj3 = make CmLearningObjectiveObject,
             :learning_objective_text => "Certificate",
             :advanced_search => true,
             :search_by_program => :set,
             :search_type => "Category",
             :category_list => nil,
             :lo_selection => 1,
             :display_level => 2,
             :defer_save => true
 learn_obj4 = make CmLearningObjectiveObject,
            :learning_objective_text => "BSCI353",
            :advanced_search => true,
            :search_by_all => :set,
            :search_type => "Code",
            :category_list => nil,
            :lo_selection => 1,
            :display_level => 1,
            :defer_save => true

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :learning_objective_list => [learn_obj1, learn_obj2, learn_obj3, learn_obj4]


  @course_proposal.determine_save_action

end

Given(/^I have a basic course proposal with Learning Objectives$/) do
  lo1_cat1 = (make CmLoCategoryObject,:category_name => 'literacy' ,
                   :auto_lookup => true,
                   :defer_save => true)
  learn_obj1 = (make CmLearningObjectiveObject, :learning_objective_text => random_alphanums(10, 'learning objective 1 '),
                                                :learning_objective_level => 3,
                                                :advanced_search => false,
                                                :display_level => 2,
                                                :defer_save => true,
                                                :category_list => [lo1_cat1])

  lo2_cat1 = (make CmLoCategoryObject,:category_name => 'Scientific',
                                                :auto_lookup => true,
                                                :defer_save => true)

  learn_obj2 = (make CmLearningObjectiveObject, :learning_objective_text => random_alphanums(10, 'learning objective 2 '),
                                                :learning_objective_level => 2,
                                                :advanced_search => false,
                                                :display_level => 3,
                                                :defer_save => true,
                                                :category_list => [lo2_cat1] )


  learn_obj3 = (make CmLearningObjectiveObject, :learning_objective_text => random_alphanums(10, 'learning objective 3 '),
                                                :learning_objective_level => 1,
                                                :advanced_search => false,
                                                :display_level => 4,
                                                :defer_save => true,
                                                :category_list => [] )


  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :learning_objective_list => [learn_obj1,learn_obj2, learn_obj3],
                                                    :defer_save => true
  # Indent LO1 under LO2
  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Indent",
                                                                          :learning_objective_level => 3

end

When(/^I edit the Learning Objectives$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action

  #Edit LO1
  @course_proposal.learning_objective_list[0].edit :learning_objective_text => "updated learning objective 1" ,
                                                   :learning_objective_level => 3,
                                                   :defer_save => true
  #Delete Category on LO1
  @course_proposal.learning_objective_list[0].category_list[0].delete :lo_level => 3,
                                                                      :category_level => 1,
                                                                      :defer_save => true
  #@course_proposal.learning_objective_list[2].category_list[0].


  #add a new category to LO1
  @course_proposal.learning_objective_list[0].add_category :category => (make CmLoCategoryObject,
                                                                                :category_name =>  "Research",
                                                                                :category_level => 3,
                                                                                :lo_level => 3,
                                                                                :auto_lookup => true,
                                                                                :defer_save => true)

  #add a new category to LO2
  @course_proposal.learning_objective_list[1].add_category :category => (make CmLoCategoryObject,
                                                                                :category_name =>  "Research",
                                                                                :category_level => 2,
                                                                                :lo_level => 2,
                                                                                :auto_lookup => true,
                                                                                :defer_save => true)

  #Outdent LO1
  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Outdent",
                                                                          :learning_objective_level => 3,
                                                                          :defer_save => true

  #Add new on the fly category to LO3
  @course_proposal.learning_objective_list[2].add_category :category => (make CmLoCategoryObject,
                                                                              :category_name =>  random_alphanums(10, 'New category LO3 '),
                                                                              :category_type => '::random::',
                                                                              :category_level => 1,
                                                                              :lo_level => 1,
                                                                              :on_the_fly => true,
                                                                              :defer_save => true)

  #Move LO1 to top
  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Up",
                                                                          :learning_objective_level => 3,
                                                                          :defer_save => true

  @course_proposal.learning_objective_list[0].organize_learning_objective :organize_action => "Up",
                                                                          :learning_objective_level => 2,
                                                                          :defer_save => true

  #Move LO3 down
  @course_proposal.learning_objective_list[2].organize_learning_objective :organize_action => "Down",
                                                                          :learning_objective_level => 2,
                                                                          :defer_save => true

  #Indent LO3 under LO2 and Save
  @course_proposal.learning_objective_list[2].organize_learning_objective :organize_action => "Indent",
                                                                          :learning_objective_level => 3,
                                                                          :defer_save => true

  #Add a new LO4
  learn_obj4 = (make CmLearningObjectiveObject, :learning_objective_text => random_alphanums(10, 'learning objective 4 '),
                     :learning_objective_level => 1,
                     :advanced_search => false,
                     :display_level => 1,
                     :defer_save => true,
                     :category_list => [] )

  @course_proposal.add_learning_objective :learn_obj => learn_obj4

  # move down the other LOs objective level
  @course_proposal.learning_objective_list[0].learning_objective_level = 2
  @course_proposal.learning_objective_list[1].learning_objective_level = 3
  @course_proposal.learning_objective_list[2].learning_objective_level = 4

end

Then(/^I should see updated Learning Objective details on the course proposal$/) do
  @course_proposal.review_proposal_action

  lo_list = @course_proposal.learning_objective_list
  on CmReviewProposalPage do |page|
    lo_list.each do |lo|
      page.learning_objectives_review(lo.display_level).should include lo.learning_objective_text
      cat_included = false

      lo.category_list.each do |cat|
        begin
          if page.learning_objectives_review(lo.display_level).should include cat.category_name
            cat_included = true
            break
          end
        rescue
          cat_included = false
        end
      end
      cat_included.should == true unless lo.category_list.length == 0
    end
  end
end

When(/^I delete the Learning Objectives$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action


  @course_proposal.learning_objective_list[0].delete :learning_objective_level => 1, :defer_save => true
  @course_proposal.learning_objective_list[1].delete :learning_objective_level => 2, :defer_save => true #delete indented outcome
  @course_proposal.learning_objective_list[1].delete :learning_objective_level => 1


end

Then(/^I should no longer see Learning Objective details on the course proposal$/) do
  @course_proposal.review_proposal_action

  lo_list = @course_proposal.learning_objective_list

  on CmReviewProposalPage do |page|
    page.learning_objectives_empty_text.exists?.should == true #implication is that no information is displayed on Learning Objective section
  end
end


