Given(/^I have an active course$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL",
                                                                             :outcome_list => [(make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample)],
                                                                             :final_exam_type => [:exam_alternate, :exam_none])], #excluded Standard Final exam due to a backlog bug
                                                    :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}" )]

  puts "Proposal Title: #{@course_proposal.proposal_title}"

  @course_proposal.approve_activate_proposal

end

When(/^I create a retire course proposal as Faculty$/) do
  steps %{Given I am logged in as Faculty}
  course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposal, :course => course,
                                                    :author_list => [(make CmAuthCollaboratorObject)],
                                                    :supporting_doc_list =>  [(make CmSupportingDocsObject)]

end


And(/^I can review the retire course proposal details$/) do
  @retire_proposal.navigate_to_retire_review
  #TODO 4 add validation steps once review page is accessible KSCM-1817
  on CmRetireProposalReviewPage do |retire|
    retire.course_number_retire_review.should == @retire_proposal.course.course_code
    retire.proposal_title_retire_review.should == @retire_proposal.retire_proposal_title
    retire.retirement_rationale_retire_review.should == @retire_proposal.retirement_rationale
    retire.start_term_retire_review.should == @retire_proposal.start_term
    retire.end_term_retire_review.should == @retire_proposal.end_term
    retire.last_term_offered_retire_review.should == @retire_proposal.last_term_offered
    retire.last_catalog_pub_year_retire_review.should == @retire_proposal.last_catalog_pub_year
    retire.other_comments_retire_review.should == @retire_proposal.other_comments

    collection_index = 0

    @retire_proposal.author_list.each do |author|
      retire.author_name_review(@retire_proposal.author_list[collection_index].author_level).should include author.name
      retire.author_permission_review(@retire_proposal.author_list[collection_index].author_level).should include "View" if author.permission == "View"
      retire.author_permission_review(@retire_proposal.author_list[collection_index].author_level).should include "Comment, View" if author.permission == "Comment, View"
      retire.author_permission_review(@retire_proposal.author_list[collection_index].author_level).should include "Edit, Comment, View" if author.permission == "Edit, Comment, View"
      retire.action_request_review(@retire_proposal.author_list[collection_index].author_level).should == "FYI"
      collection_index += 1
    end

    @retire_proposal.supporting_doc_list.each do |supporting_docs|
      retire.supporting_docs_review.should include "#{supporting_docs.file_name}.#{supporting_docs.type}"
    end
  end
end



And(/^I approve the retire course proposal as (.*?)$/) do |approver|
  log_in "carol", "carol" if approver == "Department Chair"
  log_in "earl", "earl" if approver == "College Approver"
  @retire_proposal.approve_retire_proposal
end

And(/^I blanket approve the retire course proposal as(.*?)$/) do |approver|
  log_in "alice", "alice" if approver == "Publication Chair"
  @retire_proposal.blanket_approve_retire_proposal
end

Then(/^the retire course proposal is successfully approved$/) do
    navigate_to_cm_home
    @retire_proposal.navigate_to_retire_review
    on CmRetireProposalReviewPage do |page|
      page.proposal_status.should include "approved"
    end
end

And(/^the course status is retired$/) do
  steps %{Given I am logged in as Faculty}
  @course.view_course
  on CmReviewProposal do |course_review|
    course_review.course_state_review.should include @course.course_state
  end
end


Given(/^there is a retire course proposal created as Curriculum Specialist$/) do
  # Create retire proposal
  steps %{Given I am logged in as Faculty}
  course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposal, :course => course,
                                                    :author_list => [(make CmAuthCollaboratorObject)],
                                                    :supporting_doc_list =>  [(make CmSupportingDocsObject)]

  # Navigate to review
  @retire_proposal.navigate_to_retire_review

  # Submit retire proposal
  @retire_proposal.submit_retire_proposal


end

When(/^I attempt to create a second retire proposal as Faculty$/) do
    navigate_to_functional_home
    @course.view_course
end

Then(/^I do not have the option to retire the course$/) do
  on CmReviewProposal do |page|
    begin
      page.retire_proposal_button.exists?.should be_false
    rescue
      # means the retire button was not found
    end
  end
end

When(/^I create a retire course proposal with a missing required for submit detail as Faculty$/) do
  # Create retire proposal
  steps %{Given I am logged in as Faculty}
  course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposal, :course => course,
                                                    :retirement_rationale => nil,
                                                    :author_list => [(make CmAuthCollaboratorObject)],
                                                    :supporting_doc_list => [(make CmSupportingDocsObject)]

  # Navigate to review
  @retire_proposal.navigate_to_retire_review
end

Then(/^I cannot yet submit the retire course proposal$/) do
  on CmReviewProposal do |page|
        page.submit_button_disabled.exists?.should be_true
  end
end

When(/^I complete the required for submit fields on the retire course proposal$/) do
   @retire_proposal.edit :retirement_rationale => random_alphanums(20, 'test retirement rationale ')
end

Then(/^I can submit the retire course proposal$/) do
  @retire_proposal.review_retire_proposal
  @retire_proposal.submit_retire_proposal
end

And(/^I perform a full search for the retire course proposal$/) do
  navigate_to_cm_home
  @retire_proposal.navigate_to_retire_review
end

Then(/^I can see updated status of the retire course proposal$/) do
  on CmRetireProposalReviewPage do |page|
    page.proposal_status.should include "enroute"
  end
end


When(/^I submit a retire course proposal with all fields complete as Faculty$/) do
  # Create retire proposal
  steps %{Given I am logged in as Faculty}
  course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposal, :course => course,
                            :author_list => [(make CmAuthCollaboratorObject)],
                            :supporting_doc_list =>  [(make CmSupportingDocsObject)]

  # Navigate to review
  @retire_proposal.navigate_to_retire_review

  # Submit retire proposal
  @retire_proposal.submit_retire_proposal

end
