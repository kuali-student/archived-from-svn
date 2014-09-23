Given(/^I have an active course$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                                                    :submit_fields => [(make CmSubmitFieldsObject, :subject_code => "ENGL",
                                                                             :outcome_list => [(make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample)],
                                                                             :final_exam_type => [:exam_alternate, :exam_none], :start_term => "Spring 1988")], #excluded Standard Final exam due to a backlog bug
                                                    :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}" )]
  puts "Proposal Title: #{@course_proposal.proposal_title}"
  puts "course : #{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}"

  @course_proposal.approve_activate_proposal

end

When(/^I create a retire course proposal as Faculty$/) do
  steps %{Given I am logged in as Faculty}
  @course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposalObject, :course => @course, :start_term => @course_proposal.submit_fields[0].start_term,
                                                    :author_list => [(make CmAuthCollaboratorObject)],
                                                    :supporting_doc_list =>  [(make CmSupportingDocsObject)]

  puts "Retire Proposal Title: #{@retire_proposal.retire_proposal_title}"
end


And(/^I can review the retire course proposal details$/) do
  @retire_proposal.navigate_to_retire_review
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
      retire.author_permission_review(@retire_proposal.author_list[collection_index].author_level).should include author.permission
      retire.action_request_review(@retire_proposal.author_list[collection_index].author_level).should include author.action_required
      collection_index += 1
    end

    @retire_proposal.supporting_doc_list.each do |supporting_docs|
      retire.supporting_docs_review.should include "#{supporting_docs.file_name}.#{supporting_docs.type}"
    end
  end
end



And(/^I approve the retire course proposal as (.*?)$/) do |approver|
  log_in "carol", "carol" if approver == "Department Approver"
  @retire_proposal.approve
end

And(/^I blanket approve the retire course proposal as (.*?)$/) do |approver|
  log_in "alice", "alice" if approver == "Curriculum Specialist"
  @retire_proposal.blanket_approve_retire_proposal
end

Then(/^the retire course proposal is successfully approved$/) do
    navigate_to_functional_home
    sleep 30 #TODO find a better way to avoid workflow issues
    @retire_proposal.navigate_search_retire_proposal
    on CmRetireProposalReviewPage do |page|
      page.proposal_status.should include "approved"
    end
end

And(/^the course status is retired$/) do
  steps %{Given I am logged in as Faculty}
  @course.view_course
  on CmReviewProposalPage do |course_review|
    course_review.course_state_review.should include @course.course_state.upcase
  end
end


Given(/^there is a retire course proposal created as Curriculum Specialist$/) do
  # Create retire proposal
  steps %{Given I am logged in as Curriculum Specialist}
  @course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposalObject, :admin_proposal => true,
                                                    :curriculum_review_process => :set,
                                                    :course => @course,
                                                    :start_term => @course_proposal.submit_fields[0].start_term,
                                                    :author_list => [(make CmAuthCollaboratorObject)],
                                                    :supporting_doc_list =>  [(make CmSupportingDocsObject)]


  puts "Retire Proposal Title: #{@retire_proposal.retire_proposal_title}"

  # Navigate to review
  @retire_proposal.navigate_to_retire_review

  # Submit retire proposal
  @retire_proposal.submit_retire_proposal


end

When(/^I attempt to create a second retire proposal on the same course as Faculty$/) do
    navigate_to_functional_home
    @course.view_course
end

Then(/^I do not have the option to retire the course$/) do
  on CmReviewProposalPage do |page|
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
  @course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposalObject, :course => @course,
                                                    :retirement_rationale => nil,
                                                    :author_list => [(make CmAuthCollaboratorObject)],
                                                    :supporting_doc_list => [(make CmSupportingDocsObject)]

  puts "Retire Proposal Title: #{@retire_proposal.retire_proposal_title}"

  # Navigate to review
  @retire_proposal.navigate_to_retire_review
end

Then(/^I cannot yet submit the retire course proposal$/) do
  on CmReviewProposalPage do |page|
        page.submit_button_disabled.exists?.should be_true
  end
end

When(/^I complete the required for submit fields on the retire course proposal$/) do
   @retire_proposal.edit :retirement_rationale => random_alphanums(20, 'test retirement rationale ')
end

Then(/^I can submit the retire course proposal$/) do
  @retire_proposal.navigate_to_retire_review
  @retire_proposal.submit_retire_proposal
end

And(/^I perform a full search for the retire course proposal$/) do
  navigate_to_functional_home
  @retire_proposal.navigate_search_retire_proposal
end

Then(/^I can see updated status of the retire course proposal$/) do
  on CmRetireProposalReviewPage do |page|
    page.proposal_status.should include "enroute"
  end
end


When(/^I submit a retire course proposal with all fields complete as Faculty$/) do
  # Create retire proposal
  steps %{Given I am logged in as Faculty}
  @course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposalObject, :course => @course,
                            :author_list => [(make CmAuthCollaboratorObject)],
                            :supporting_doc_list => [(make CmSupportingDocsObject)]

  puts "Retire Proposal Title: #{@retire_proposal.retire_proposal_title}"
  # Navigate to review
  @retire_proposal.navigate_to_retire_review

  # Submit retire proposal
  @retire_proposal.submit_retire_proposal

end

When(/^I create a administrative retire as Curriculum Specialist$/) do
  # Create retire proposal
  steps %{Given I am logged in as Curriculum Specialist}
  @course = make CmCourseObject, :search_term => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 :course_code => "#{@course_proposal.submit_fields[0].subject_code}#{@course_proposal.approve_fields[0].course_number}",
                 :course_state => "Retired"

  @retire_proposal = create CmRetireCourseProposalObject, :admin_proposal => true,
                                                    :course => @course,
                                                    :author_list => nil,
                                                    :supporting_doc_list =>  nil

  puts "Retire Proposal Title: #{@retire_proposal.retire_proposal_title}"

end

Then(/^I can approve and retire the admin retire proposal$/) do
  # Approve and Retire Proposal
  @retire_proposal.approve_retire_proposal
end

And(/^the course is retired$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course.view_course
  on CmReviewProposalPage do |course_review|
    course_review.course_state_review.should include @course.course_state.upcase
  end
end

When(/^I attempt to create a second admin retire proposal$/) do
  navigate_to_functional_home
  @course.view_course
end

Then(/^I can review the retire course proposal details and submit$/) do
  #@retire_proposal.navigate_to_retire_review
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
      retire.author_permission_review(@retire_proposal.author_list[collection_index].author_level).should include author.permission
      retire.action_request_review(@retire_proposal.author_list[collection_index].author_level).should include author.action_required
      collection_index += 1
    end

    @retire_proposal.supporting_doc_list.each do |supporting_docs|
      retire.supporting_docs_review.should include "#{supporting_docs.file_name}.#{supporting_docs.type}"
    end
  end

end