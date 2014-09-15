Given(/^I have a basic course proposal created as Faculty$/) do
  steps %{Given I am logged in as Faculty}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false, :create_basic_propsal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')
  @course_proposal.create_course_continue
  @course_proposal.create_basic_proposal
end

When(/^I add comments to the course proposal$/) do
  @course_proposal.load_comments_action
  @comment_add = create CmCommentsObject
  @comment_add.close_comment_dialog
end

Then(/^I should see my comments on the course proposal$/) do
  steps %{And edit the course proposal after finding it}
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (1)"
    page.comment_content_text(0).should == @comment_add.commentText
  end
end

Given(/^I have a basic course admin proposal created as Curriculum Specialist$/) do
  steps %{Given I am logged in as Curriculum Specialist}
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false, :create_basic_propsal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')
  @course_proposal.create_course_continue
  @course_proposal.create_basic_proposal
end

Given(/^I have a basic course proposal with comments created as Faculty$/) do
  steps %{Given I have a basic course proposal created as Faculty}
  steps %{When I add comments to the course proposal}
end

When(/^I edit a comment$/) do
  @course_proposal.load_comments_action
  sleep 1
  @comment_add.edit :index=>0, :commentText=>random_alphanums(10,'edit proposal comment')
  @comment_add.close_comment_dialog
  on CmCourseInformationPage do |page|
    if(page.alert.exists?)
      page.alert.ok
    end
  end
end

Then(/^I should see my edited comments on the course proposal$/) do
  steps %{And edit the course proposal after finding it}
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (1)"
    page.comment_content_text(0).should == @comment_add.commentText
  end
end

And(/^I delete my comments$/) do
  @course_proposal.load_comments_action
  sleep 1
  @comment_add.delete :index=>0
  @comment_add.close_comment_dialog
end

Then(/^I should not see any comments on the course proposal$/) do
  steps %{And edit the course proposal after finding it}
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (0)"
  end
end

Given(/^I have a basic course admin proposal with comments created as CS$/) do
  steps %{Given I have a basic course admin proposal created as Curriculum Specialist}
  steps %{When I add comments to the course proposal}
end

And(/^I undo delete of one comment$/) do
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (0)"
    page.undo_delete_comment_link.exists?.should == true
    page.undo_delete
    page.close_dialog
  end
end

Then(/^I should see the undeleted comment on the course admin proposal$/) do
  steps %{And review the course proposal after finding it}
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (1)"
    page.comment_content_text(0).should == @comment_add.commentText
  end
end

Given(/^I have a basic course proposal with comments created as Faculty with comments by CS$/) do
  steps %{Given I have a basic course proposal with comments created as Faculty}
  steps %{Given I am logged in as Curriculum Specialist}
  steps %{When I perform a search for the course proposal}
  steps %{And edit the course proposal after finding it}
  steps %{When I add comments to the course proposal}
  steps %{Given I am logged in as Faculty}
end

Then(/^I should see my comments and CS comments on the course proposal$/) do
  steps %{And review the course proposal after finding it}
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (2)"
    page.comment_content_text(0).should == @comment_add.commentText
    (page.comment_header_id_text(0).include? "alice").should == true
    (page.comment_header_id_text(1).include? "fred").should == true
  end
end

And(/^I should not have edit or delete options for CS comments$/) do
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (2)"
    begin
    page.comment_edit_link(0).should_not exist
    page.comment_delete_link(0).should_not exist
    rescue
    #means the element was not found and exception was encountered when calling by index
    end
    page.comment_edit_link(1).should exist
    page.comment_delete_link(1).should exist
  end
end

Then(/^I should see CS comments on the course proposal$/) do
  steps %{And review the course proposal after finding it}
  on CmProposalCommentsPage do |page|
    page.comment_list_header_text.should == "Comments (1)"
    page.comment_content_text(0).should == @comment_add.commentText
  end
end

And(/^I should not have ability to add comments$/) do
  on CmProposalCommentsPage do |page|
    begin
    page.comment_text_input.should_not exist
    page.add_comment_button.should_not exist
    rescue
     #means the element was not found and exception was encountered.
    end
  end
end

And (/^edit the course proposal after finding it$/) do
  @course_proposal.edit_proposal_action
  @course_proposal.load_comments_action
  sleep 1
end

When (/^I delete my comments without closing comment dialog$/) do
  @course_proposal.load_comments_action
  sleep 1
  @comment_add.delete :index=>0
end

And (/^review the course proposal after finding it$/) do
  @course_proposal.review_proposal_action
  @course_proposal.load_comments_on_review_page
end
