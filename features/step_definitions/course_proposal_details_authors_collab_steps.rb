Given(/^I have a proposal with collaborators submitted as (.*?)$/) do |author|
  log_in author, author

  outcome = (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample)
  submit_fields = (make CmSubmitFieldsObject, :subject_code => "BMGT",
                        :outcome_list => [outcome],
                        :final_exam_type => [:exam_standard])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [submit_fields],
                            :author_list => []

  puts @course_proposal.proposal_title

end


Then(/^(.*?) can FYI the proposal$/) do |fyi_view_collaborator|
  log_in fyi_view_collaborator, fyi_view_collaborator
  @course_proposal.navigate_to_review

  on CmReviewProposal do |page|
    begin
      page.edit_course_information.should_not exist
    rescue
      #implies that edit course information was not found
    end
    page.fyi_button.exists?.should be_true
  end
end


And(/^cannot comment on the proposal$/) do

  on CmReviewProposal do |page|
    begin
      page.edit_course_information.should_not exist
    rescue
      #means the element was not found and exception was encountered.
    end
  end

  @course_proposal.load_comments_action
  on CmProposalComments do |page|
    begin
      page.comment_text_input.should_not exist
      page.add_comment_button.should_not exist

    rescue
      #means the element was not found and exception was encountered.
    end
  end
end


Given(/^I have a proposal with submit and approve fields with collaborators submitted as (.*?)$/) do |author|
  log_in author, author

  outcome = (make CmOutcomeObject, :outcome_type => "Fixed", :outcome_level => 0, :credit_value=>(1..5).to_a.sample)
  submit_fields = (make CmSubmitFieldsObject, :subject_code => "ENGL",
                        :outcome_list => [outcome],
                        :final_exam_type => [:exam_standard])

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [submit_fields],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => "#{(900..999).to_a.sample}" )],
                            :author_list => []

  puts @course_proposal.proposal_title

  @course_proposal.submit_proposal

end



And(/^authors and collaborators added by (.*?)$/) do |approver|
  log_in approver, approver
  @course_proposal.navigate_to_review
  @course_proposal.edit

  @course_proposal.add_author :author =>(make CmAuthCollaboratorObject,
                                              :name => "Edna",
                                              :lookup_value => "Employee",
                                              :action_required => "FYI",
                                              :permission => "View",
                                              :author_notation => :clear,
                                              :author_level => 1,
                                              :auto_lookup => true,
                                              :defer_save => true)

  @course_proposal.add_author :author =>(make CmAuthCollaboratorObject,
                                              :name => "Eric",
                                              :lookup_value => "Employee",
                                              :action_required => "Acknowledge",
                                              :permission => "Comment, View",
                                              :author_notation => :clear,
                                              :author_level => 2,
                                              :auto_lookup => true,
                                              :defer_save => true)

  @course_proposal.add_author :author =>(make CmAuthCollaboratorObject,
                                              :name => "Erin",
                                              :lookup_value => "Employee",
                                              :action_required => "Approve",
                                              :permission => "Edit, Comment, View",
                                              :author_notation => :clear,
                                              :author_level => 3,
                                              :auto_lookup => true)
end




And(/^(.*?) can FYI and comment on the proposal$/) do |fyi_comment_collaborator|
  log_in fyi_comment_collaborator, fyi_comment_collaborator
  @course_proposal.navigate_to_review
  on CmReviewProposal do |page|
    page.fyi_button.exists?.should be_true
  end
  @course_proposal.load_comments_action

  on CmProposalComments do |page|
      page.comment_text_input.should exist
      page.add_comment_button.should exist
    end
end




And(/^can Comment on the proposal$/) do
  pending # express the regexp above with the code you wish you had
end

And(/^cannot edit the proposal$/) do
  on CmReviewProposal do |page|
    begin
    page.edit_course_information.should_not exist
    rescue
     #means the element was not found and exception was encountered.
    end
  end
end

And(/^(.*?) Edits and Submits the proposal$/) do |fyi_edit_collaborator|
  log_in fyi_edit_collaborator, fyi_edit_collaborator
  @course_proposal.navigate_to_review
  on CmReviewProposal do |page|
    page.fyi_button.should exist
  end
  @course_proposal.edit :proposal_title => "updated #{random_alphanums(10,'by edit collaborator ') }"
  @course_proposal.submit_proposal
end


Then(/^(.*?) can no longer edit the proposal$/) do |fyi_edit_collaborator|
  on CmReviewProposal do |page|
    page.proposal_status.should include "enroute"
    begin
      page.edit_course_information.should_not exist
    rescue
      #means the element was not found and exception was encountered.
    end
  end
end


And(/^(.*?) can Acknowledge and Comment on the proposal$/) do |acknowledge_comment_collaborator|
  log_in acknowledge_comment_collaborator, acknowledge_comment_collaborator
  @course_proposal.navigate_to_review
  
  on CmReviewProposal do |page|
    begin
      page.edit_course_information.should_not exist
    rescue
      #means the element was not found and exception was encountered.
    end
    page.acknowledge_button.should exist
  end

  @course_proposal.load_comments_action

  on CmProposalComments do |page|
    page.comment_text_input.should exist
    page.add_comment_button.should exist
  end
  

end

When(/^(.*?) Edits and Approves the proposal$/) do |approve_edit_collaborator|
    log_in approve_edit_collaborator, approve_edit_collaborator
    @course_proposal.navigate_to_review
    on CmReviewProposal do |page|
      page.approve_button.should exist
    end
    @course_proposal.edit :proposal_title => "updated #{random_alphanums(10,'by approve edit collaborator ') }"
    navigate_to_functional_home
    @course_proposal.approve_proposal



end

