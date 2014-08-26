When(/^I add Optional\-Other details to the course proposal$/) do
  #Add 2 Instructors
  #Add Governance --> Administering Orgs

  #Add Course Logistics -->Term - select three of the options
  #Add Course Logistics -->Duration Type - select one of the options
  #Add Course Logistics -->Duration Count - enter any 1-3 digit number
  #Add Course Logistics -->Audit - select
  #Add Course Logistics -->Pass Fail Transcript Grade - select

  #Add Active Date --> Pilot Course - select
  #Add Active Date --> End Date - select

  #Add Financials --> Justification of Fees

end


And(/^I perform a search for the course proposal with given proposal ID$/) do
  navigate_to_cm_home
  @course_proposal.search
  on FindProposalPage do |page|
    page.review_proposal_action_link(@course_proposal.proposal_title)
    page.loading_wait
  end
  sleep 1
end

Then(/^I should see Optional\-Other details on the course proposal$/) do
  @course_proposal.review_proposal_action
  on CmReviewProposal do |page|
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    @course_proposal.optional_fields[0].instructor_list.each do |instructor|
      page.instructors_review.should include instructor.instructor_name
    end

    @course_proposal.optional_fields[0].admin_org_list.each do |admin_org|
      page.administering_org_review.should include admin_org.admin_org_name
    end

    page.terms_review.should include "Any" if @course_proposal.optional_fields[0].term_any == :set
    page.terms_review.should include "Fall" if @course_proposal.optional_fields[0].term_fall == :set
    page.terms_review.should include "Spring" if @course_proposal.optional_fields[0].term_spring == :set
    page.terms_review.should include "Summer" if @course_proposal.optional_fields[0].term_summer == :set

    page.duration_review.should include "#{@course_proposal.optional_fields[0].duration_type}"
    page.duration_review.should include "#{@course_proposal.optional_fields[0].duration_count}"

    page.audit_review.should == "Yes" if @course_proposal.optional_fields[0].audit == :set
    page.pass_fail_transcript_review.should == "Yes" if @course_proposal.optional_fields[0].pass_fail_transcript_grade == :set

    page.pilot_course_review.should == "Yes" if @course_proposal.optional_fields[0].pilot_course == :set
    page.end_term_review.should == @course_proposal.optional_fields[0].end_term
    page.fee_justification_review.should == @course_proposal.optional_fields[0].justification_of_fees


  end
end

When(/^I create a course proposal with Optional\-Other fields$/) do
  @course_proposal = create CmCourseProposalObject, :optional_fields => [(make CmOptionalFieldsObject)],
                                                    :create_new_proposal => true,
                                                    :create_optional_fields => true




end

Given(/^I have a basic course admin proposal with Optional\-Other details created as CS$/) do
  pending # express the regexp above with the code you wish you had
  #put some code here
end

When(/^I update the Optional Other details on the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action

  @course_proposal.optional_fields[0].instructor_list[0].delete :instructor_level => 1, :defer_save => true
  @course_proposal.optional_fields[0].instructor_list[1].edit :instructor_name => "MILES", :instructor_level => 1, :defer_save => true

  @course_proposal.optional_fields[0].admin_org_list[0].delete :admin_org_level => 1, :defer_save => true
  @course_proposal.optional_fields[0].admin_org_list[1].edit :admin_org_name => "Avian", :admin_org_level => 1, :defer_save => true

  @course_proposal.optional_fields[0].edit :term_any => :clear,
                                           :term_fall => :clear,
                                           :term_summer => :set,
                                           :duration_type => '::random::',
                                           :duration_count => (1..999).to_a.sample,
                                           :pilot_course => :clear,
                                           :defer_save => true

  @course_proposal.edit :start_term => "Spring 1980", :defer_save => true

  @course_proposal.optional_fields[0].edit :justification_of_fees => "updated justification text"


end

Then(/^I should see updated Optional Other details on the course proposal$/) do
  @course_proposal.review_proposal_action
  on CmReviewProposal do |page|
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    page.instructors_review.should include @course_proposal.optional_fields[0].instructor_list[1].instructor_name
    page.administering_org_review.should include @course_proposal.optional_fields[0].admin_org_list[1].admin_org_name


    page.terms_review.should include "Any" if @course_proposal.optional_fields[0].term_any == :set
    page.terms_review.should include "Fall" if @course_proposal.optional_fields[0].term_fall == :set
    page.terms_review.should include "Spring" if @course_proposal.optional_fields[0].term_spring == :set
    page.terms_review.should include "Summer" if @course_proposal.optional_fields[0].term_summer == :set

    page.duration_review.should include "#{@course_proposal.optional_fields[0].duration_type}"
    page.duration_review.should include "#{@course_proposal.optional_fields[0].duration_count}"

    page.audit_review.should == "Yes" if @course_proposal.optional_fields[0].audit == :set
    page.pass_fail_transcript_review.should == "Yes" if @course_proposal.optional_fields[0].pass_fail_transcript_grade == :set

    page.pilot_course_review.should == "Yes" if @course_proposal.optional_fields[0].pilot_course == :set

    page.end_term_review.should_not == @course_proposal.optional_fields[0].end_term
    page.fee_justification_review.should == @course_proposal.optional_fields[0].justification_of_fees


  end
end

And(/^I have a basic course proposal created with Optional-Other fields$/) do
  @course_proposal = create CmCourseProposalObject, :optional_fields => [(make CmOptionalFieldsObject)],
                                                    :create_new_proposal => true,
                                                    :create_optional_fields => true

end

When(/^I delete Optional\-Other details on the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action

  @course_proposal.optional_fields[0].instructor_list[0].delete :instructor_level => 1, :defer_save => true
  @course_proposal.optional_fields[0].instructor_list[0].delete :instructor_level => 1, :defer_save => true
  @course_proposal.optional_fields[0].admin_org_list[0].delete :admin_org_level => 1, :defer_save => true
  @course_proposal.optional_fields[0].admin_org_list[0].delete :admin_org_level => 1, :defer_save => true

  @course_proposal.optional_fields[0].edit :term_any => :clear,
                                           :term_fall => :clear,
                                           :term_spring => :clear,
                                           :term_summer => :clear,
                                           :duration_type => "",
                                           :duration_count => "",
                                           :audit => :clear,
                                           :pass_fail_transcript_grade => :clear,
                                           :pilot_course => :clear,
                                           :justification_of_fees => " "

end

Then(/^I should no longer see Optional\-Other details on the course proposal$/) do
  @course_proposal.review_proposal_action
  on CmReviewProposal do |page|
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    @course_proposal.optional_fields[0].instructor_list.each do |instructor|
      page.instructors_review.should_not include instructor.instructor_name
    end

    @course_proposal.optional_fields[0].admin_org_list.each do |admin_org|
      page.administering_org_review.should_not include admin_org.admin_org_name
    end

    page.terms_review.should_not include "Any"
    page.terms_review.should_not include "Fall"
    page.terms_review.should_not include "Spring"
    page.terms_review.should_not include "Summer"

    page.duration_review.should include "#{@course_proposal.optional_fields[0].duration_type}"
    page.duration_review.should include "#{@course_proposal.optional_fields[0].duration_count}"

    page.audit_review.should_not == "Yes"
    page.pass_fail_transcript_review.should_not == "Yes"

    page.pilot_course_review.should_not == "Yes"
    page.end_term_review.should_not == @course_proposal.optional_fields[0].end_term
    page.fee_justification_review.should == ""

  end
end


When(/^I create a basic course proposal with Learning Objectives using category lookup$/) do
  lo1_cat1 = (make CmLoCategoryObject,:category_name => random_alphanums(10),
                                      :on_the_fly => true,
                                      :defer_save => true)
  learn_obj1 = (make CmLearningObjectiveObject, :learning_objective_text => "learning objective text1",
                                                :defer_save => true,
                                                :display_level => 2,
                                                :category_list => [lo1_cat1])

  lo2_cat1 = (make CmLoCategoryObject,:category_name => "literacy",
                                      :category_level => 1,
                                      :category_selection => 1,
                                      :auto_lookup => true,
                                      :defer_save => true)

  lo2_cat2 = (make CmLoCategoryObject,:category_name => "Communication",
                                      :advanced_search => true,
                                      :category_selection => 2,
                                      :defer_save => true)

  lo2_cat3 = (make CmLoCategoryObject,:category_name => "Critical",
                                      :advanced_search => true,
                                      :category_selection => 1,
                                      :defer_save => true)

  learn_obj2 = (make CmLearningObjectiveObject, :learning_objective_level => 2,
                                                :learning_objective_text => "learning objective text 2",
                                                :defer_save => true,
                                                :display_level => 1,
                                                :category_list => [lo2_cat1, lo2_cat2, lo2_cat3])


  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :learning_objective_list => [learn_obj1, learn_obj2]


end


Then(/^I should see Learning Objective and category details on the course proposal$/) do
  @course_proposal.review_proposal_action

  lo_list = @course_proposal.learning_objective_list
  on CmReviewProposal do |page|
    lo_list.each do |lo|
      page.learning_objectives_review(lo.display_level).should include lo.learning_objective_text
        lo.category_list.each do |cat|
          page.learning_objectives_review(lo.display_level).downcase.should include cat.category_name.downcase
        end
    end
  end


end


Then(/^I should see Learning Objective details on the course proposal$/) do
  @course_proposal.review_proposal_action

  lo_list = @course_proposal.learning_objective_list
    on CmReviewProposal do |page|
      lo_list.each do |lo|
        page.learning_objectives_review(lo.display_level).should include lo.learning_objective_text
      end
  end

end

When(/^I create a basic course proposal with authors and collaborators$/) do
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :author_list => [(make CmAuthCollaboratorObject, :defer_save => true ),
                                                                     (make CmAuthCollaboratorObject, :name => "AVILA", :author_level => 2, :permission => "Comment, View", :author_notation => :clear, :defer_save => true),
                                                                     (make CmAuthCollaboratorObject, :name => "CHURCH", :author_level => 3, :permission => "Edit, Comment, View", :author_notation => :clear)
                                                                     ],
                                                    :defer_save => true
end

Then(/^I should see author and collaborator details on the course proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title
    collection_index = 0

      @course_proposal.author_list.each do |author|
          page.author_name_review(@course_proposal.author_list[collection_index].author_level).should include author.name
          page.author_permission_review(@course_proposal.author_list[collection_index].author_level).should include "View" if author.permission == "View"
          page.author_permission_review(@course_proposal.author_list[collection_index].author_level).should include "Comment, View" if author.permission == "Comment, View"
          page.author_permission_review(@course_proposal.author_list[collection_index].author_level).should include "Edit, Comment, View" if author.permission == "Edit, Comment, View"
          page.action_request_review(@course_proposal.author_list[collection_index].author_level).should == "FYI"
          collection_index += 1
      end
    end
  end


Given(/^have a basic course proposal with authors and collaborators$/) do
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :author_list => [(make CmAuthCollaboratorObject, :defer_save => true ),
                                             (make CmAuthCollaboratorObject, :name => "AVILA", :author_level => 2, :permission => "Comment, View", :author_notation => :clear),

                            ],
                            :defer_save => true
end

When(/^I update the author and collaborator details on the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action
  @course_proposal.author_list[0].delete :author_level => 1, :defer_save => true
  @course_proposal.add_author :author =>(make CmAuthCollaboratorObject,
                                                             :name => "SMITH",
                                                             :author_notation => :clear,
                                                             :permission => "Comment, View",
                                                             :author_level => 2,
                                                             :auto_lookup => true)
end

Then(/^I should see updated author and collaborator details on the course proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title
    collection_index = 1
    begin
      page.author_name_review(collection_index).should include @course_proposal.author_list[collection_index].name
      page.author_permission_review(collection_index).should include "View" if @course_proposal.author_list[collection_index].permission == "View"
      page.author_permission_review(collection_index).should include "Comment, View" if @course_proposal.author_list[collection_index].permission == "Comment, View"
      page.author_permission_review(collection_index).should include "Edit, Comment, View" if @course_proposal.author_list[collection_index].permission == "Edit, Comment, View"
      page.action_request_review(collection_index).should == "FYI"
      collection_index += 1
    end until collection_index == 2

  end
end

When(/^I delete the author and collaborator details on the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action
  @course_proposal.author_list[0].delete :author_level => 1, :defer_save => true
  @course_proposal.author_list[1].delete :author_level => 1
end

Then(/^I should no longer see author and collaborator details on the course proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title
    collection_index = 0

    page.empty_authors_collab_review.exists?.should == true #implication is that no information is displayed on authors and collaborators section

   end
end

When(/^I create a basic course proposal with Supporting Documents$/) do
  support_doc1 = (make CmSupportingDocsObject, :defer_save => true)
  support_doc2 = (make CmSupportingDocsObject,:document_level => 2, :defer_save => true)
  support_doc3 = (make CmSupportingDocsObject,:document_level => 3 )

   @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                     :supporting_doc_list => [support_doc1, support_doc2,support_doc3],
                                                     :defer_save => true
end


Then(/^I should see Supporting Documents details on the course proposal$/) do
  @course_proposal.review_proposal_action

  on CmReviewProposal do |page|
    page.proposal_title_review.should == @course_proposal.proposal_title
    page.course_title_review.should == @course_proposal.course_title

    #Supporting Documents
      @course_proposal.supporting_doc_list.each do |supporting_docs|
         page.supporting_docs_review.should include "#{supporting_docs.file_name}.#{supporting_docs.type}"
      end

  end

end

Given(/^I have a basic course proposal with Supporting Documents$/) do
  support_doc1 = (make CmSupportingDocsObject, :defer_save => true)
  support_doc2 = (make CmSupportingDocsObject,:document_level => 2, :defer_save => true)
  support_doc3 = (make CmSupportingDocsObject,:document_level => 3 )
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :supporting_doc_list => [support_doc1, support_doc2, support_doc3],
                                                    :defer_save => false
end


When(/^I update the Supporting Documents on the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action

  # Delete 1st Supporting Doc [0]
  @course_proposal.supporting_doc_list[0].delete :document_level => 1, :defer_save => true

  # Edit Description on 2nd Supporting Doc [1]
  @course_proposal.supporting_doc_list[1].delete :document_level => 1, :defer_save => true
  @course_proposal.add_supporting_doc :supporting_doc => (make CmSupportingDocsObject, :document_level=> 2, :defer_save => true), :defer_save => true

  # Add a new supporting doc [3]
  @course_proposal.add_supporting_doc :supporting_doc => (make CmSupportingDocsObject, :document_level => 3, :defer_save => true )

end


Then(/^I should see updated Supporting Documents details on the course proposal$/) do
  @course_proposal.review_proposal_action
  on CmReviewProposal do |page|
    collection_index = 2 #exclude deleted items [0] and [1]
    supporting_doc_list = @course_proposal.supporting_doc_list
    begin
      page.supporting_docs_review.should include "#{supporting_doc_list[collection_index].file_name}.#{supporting_doc_list[collection_index].type}"
      collection_index += 1
    end until collection_index == supporting_doc_list.count
  end
end

When(/^I delete the Supporting Documents on the course proposal$/) do
  navigate_to_cm_home
  @course_proposal.search
  @course_proposal.edit_proposal_action

  @course_proposal.supporting_doc_list[0].delete :document_level => 1, :defer_save => true
  @course_proposal.supporting_doc_list[1].delete :document_level => 1, :defer_save => true
  @course_proposal.supporting_doc_list[2].delete :document_level => 1

end

Then(/^I should no longer see Supporting Documents on the course proposal$/) do
  @course_proposal.review_proposal_action
    on CmReviewProposal do |page|
      page.proposal_title_review.should == @course_proposal.proposal_title
      page.course_title_review.should == @course_proposal.course_title
      @course_proposal.supporting_doc_list.each do |supporting_docs|
        page.supporting_docs_review.should_not include "#{supporting_docs.file_name}.#{supporting_docs.type}"
      end
  end
end
